from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Flowable
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_JUSTIFY
import os

# ── DEEP TEAL PALETTE ────────────────────────────────────────────
DARK     = colors.HexColor("#021214")
ACCENT   = colors.HexColor("#0D9488")   
ACCENT_L = colors.HexColor("#CCFBF1")
GREEN    = colors.HexColor("#16A34A");  GREEN_L  = colors.HexColor("#DCFCE7")
RED      = colors.HexColor("#DC2626");  RED_L    = colors.HexColor("#FEE2E2")
BLUE     = colors.HexColor("#1D4ED8");  BLUE_L   = colors.HexColor("#DBEAFE")
AMBER    = colors.HexColor("#D97706");  AMBER_L  = colors.HexColor("#FEF3C7")
TEAL     = colors.HexColor("#0F766E");  TEAL_L   = colors.HexColor("#CCFBF1")
PURPLE   = colors.HexColor("#7C3AED"); PURPLE_L = colors.HexColor("#EDE9FE")
GRAY_D   = colors.HexColor("#1F2937"); GRAY_L   = colors.HexColor("#F3F4F6")
CODE_BG  = colors.HexColor("#0D1117"); CODE_FG  = colors.HexColor("#E6EDF3")
CODE_CMT = colors.HexColor("#8B949E")
WHITE    = colors.white
PW, PH   = A4

class AccentBar(Flowable):
    def __init__(self, color=None, h=4, frac=0.10):
        super().__init__()
        self.color = color if color else ACCENT
        self.bh = h; self.frac = frac
        self.width = 0; self.height = h + 4
    def draw(self):
        self.canv.setFillColor(self.color)
        self.canv.rect(0, 0, self.width*self.frac, self.bh, fill=1, stroke=0)

class HR(Flowable):
    def __init__(self, color, t=1):
        super().__init__()
        self.color = color; self.t = t; self.width = 0; self.height = t + 2
    def draw(self):
        self.canv.setStrokeColor(self.color)
        self.canv.setLineWidth(self.t)
        self.canv.line(0, 0, self.width, 0)

def make_styles():
    s = {}
    s['ct']  = ParagraphStyle('ct',  fontName='Helvetica-Bold', fontSize=24, textColor=WHITE, leading=32, alignment=TA_CENTER)
    s['cs']  = ParagraphStyle('cs',  fontName='Helvetica',      fontSize=13, textColor=colors.HexColor("#99F6E4"), leading=20, alignment=TA_CENTER)
    s['ctg'] = ParagraphStyle('ctg', fontName='Helvetica',      fontSize=10, textColor=colors.HexColor("#CCFBF1"), leading=16, alignment=TA_CENTER)
    s['sec'] = ParagraphStyle('sec', fontName='Helvetica-Bold', fontSize=18, textColor=ACCENT, leading=24, spaceBefore=14, spaceAfter=4)
    s['sub'] = ParagraphStyle('sub', fontName='Helvetica-Bold', fontSize=13, textColor=GRAY_D, leading=20, spaceBefore=10, spaceAfter=3)
    s['body']= ParagraphStyle('body',fontName='Helvetica',      fontSize=10.5, textColor=GRAY_D, leading=17, spaceBefore=3, spaceAfter=3, alignment=TA_JUSTIFY)
    s['sb']  = ParagraphStyle('sb',  fontName='Helvetica',      fontSize=10,   textColor=GRAY_D, leading=16, spaceBefore=2, spaceAfter=2)
    s['code']= ParagraphStyle('code',fontName='Courier',        fontSize=9,    textColor=CODE_FG, leading=14, leftIndent=10)
    s['cmt'] = ParagraphStyle('cmt', fontName='Courier-Oblique',fontSize=9,    textColor=CODE_CMT,leading=14, leftIndent=10)
    s['th']  = ParagraphStyle('th',  fontName='Helvetica-Bold', fontSize=9.5,  textColor=WHITE, leading=14, alignment=TA_CENTER)
    s['tc']  = ParagraphStyle('tc',  fontName='Helvetica',      fontSize=9,    textColor=GRAY_D, leading=14)
    s['ct2'] = ParagraphStyle('ct2', fontName='Helvetica-Bold', fontSize=10,   textColor=ACCENT, leading=15, spaceAfter=2)
    s['cb']  = ParagraphStyle('cb',  fontName='Helvetica',      fontSize=10,   textColor=GRAY_D, leading=16, spaceBefore=1, spaceAfter=1)
    s['toc'] = ParagraphStyle('toc', fontName='Helvetica',      fontSize=11,   textColor=GRAY_D, leading=20, leftIndent=8)
    s['ton'] = ParagraphStyle('ton', fontName='Helvetica-Bold', fontSize=11,   textColor=ACCENT, leading=20)
    s['iq']  = ParagraphStyle('iq',  fontName='Helvetica-Bold', fontSize=11,   textColor=PURPLE, leading=18, spaceBefore=8, spaceAfter=3)
    s['ia']  = ParagraphStyle('ia',  fontName='Helvetica',      fontSize=10.5, textColor=GRAY_D, leading=17, spaceBefore=2, spaceAfter=2, alignment=TA_JUSTIFY)
    s['ib']  = ParagraphStyle('ib',  fontName='Helvetica-Bold', fontSize=10.5, textColor=GRAY_D, leading=17, spaceBefore=2, spaceAfter=2)
    return s

def sec(t, s, color=None):
    c = color if color else ACCENT
    return [Spacer(1,8), AccentBar(c), Paragraph(t, s['sec']), HR(c, 1.5), Spacer(1,5)]

def body_p(t, s): return Paragraph(t, s['body'])

def code_block(lines, s):
    rows = []
    for ln in lines:
        st = ln.strip()
        style = s['cmt'] if (st.startswith('//') or st.startswith('#')) else s['code']
        rows.append(Paragraph(ln if ln else ' ', style))
    t = Table([[r] for r in rows], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),CODE_BG),
        ('TOPPADDING',(0,0),(-1,0),8),('BOTTOMPADDING',(0,-1),(-1,-1),8),
        ('LEFTPADDING',(0,0),(-1,-1),12),('ROWPADDING',(0,0),(-1,-1),3),
    ]))
    return [t, Spacer(1,6)]

def callout(title, lines, color, bg, s):
    content = [Paragraph(title, s['ct2'])] + [Paragraph(l, s['cb']) for l in lines]
    t = Table([[content]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),bg),('LINEBEFORE',(0,0),(0,-1),4,color),
        ('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),14),('RIGHTPADDING',(0,0),(-1,-1),10),
    ]))
    return [t, Spacer(1,8)]

def story_box(paras, s):
    content = [Paragraph(p, s['sb']) for p in paras]
    t = Table([[content]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),ACCENT_L),('LINEBEFORE',(0,0),(0,-1),4,ACCENT),
        ('TOPPADDING',(0,0),(-1,-1),12),('BOTTOMPADDING',(0,0),(-1,-1),12),
        ('LEFTPADDING',(0,0),(-1,-1),16),('RIGHTPADDING',(0,0),(-1,-1),12),
    ]))
    return [t, Spacer(1,10)]

def tip_box(lines, s):   return callout('&#9989;  Key Rule', lines, GREEN, GREEN_L, s)
def warn_box(lines, s):  return callout('&#10060;  Common Mistake', lines, RED, RED_L, s)
def iptr(lines, s):      return callout('&#128304;  Interview Pointer', lines, BLUE, BLUE_L, s)
def varbox(lines, s):    return callout('&#128161;  Key Insight', lines, AMBER, AMBER_L, s)

def diff_table(headers, rows, s, col_w=None, hcolor=ACCENT):
    if not col_w:
        col_w = [int(155/len(headers))*mm]*len(headers)
    data = [[Paragraph(h, s['th']) for h in headers]]
    for row in rows:
        data.append([Paragraph(str(c), s['tc']) for c in row])
    t = Table(data, colWidths=col_w, repeatRows=1)
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),hcolor),
        ('ROWBACKGROUNDS',(0,1),(-1,-1),[WHITE, GRAY_L]),
        ('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#E5E7EB')),
        ('TOPPADDING',(0,0),(-1,-1),5),('BOTTOMPADDING',(0,0),(-1,-1),5),
        ('LEFTPADDING',(0,0),(-1,-1),8),('VALIGN',(0,0),(-1,-1),'TOP'),
    ]))
    return [t, Spacer(1,10)]

def iqa(q_num, question, answer_paras, s):
    items = [Paragraph(f"Q{q_num}. {question}", s['iq'])]
    content = []
    for p in answer_paras:
        if p.startswith('**') and p.endswith('**'):
            content.append(Paragraph(p[2:-2], s['ib']))
        else:
            content.append(Paragraph(p, s['ia']))
    t = Table([[content]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),PURPLE_L),('LINEBEFORE',(0,0),(0,-1),4,PURPLE),
        ('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),14),('RIGHTPADDING',(0,0),(-1,-1),12),
    ]))
    items += [t, Spacer(1,10)]
    return items

def build_cover(s):
    items = []
    inner = [
        Spacer(1,14*mm),
        Paragraph('JAVA COLLECTIONS & CORE CONCEPTS', s['ct']),
        Paragraph('Comparator Design Pattern, Identity & Weak Maps, Legacy Classes — TAP Academy', s['cs']),
        Spacer(1,4*mm), HR(colors.HexColor('#99F6E4'),2), Spacer(1,4*mm),
        Paragraph('Custom Sorting &bull; Memory management &bull; Threads &bull; TAP Academy Excellence', s['ctg']),
        Spacer(1,14*mm),
    ]
    t = Table([[inner]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),DARK),
        ('TOPPADDING',(0,0),(-1,-1),20),('BOTTOMPADDING',(0,0),(-1,-1),20),
        ('LEFTPADDING',(0,0),(-1,-1),20),('RIGHTPADDING',(0,0),(-1,-1),20),
    ]))
    items.append(t); items.append(Spacer(1,8*mm))
    items.append(PageBreak())
    return items

def on_page(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(DARK)
    canvas.rect(0, 0, PW, 18, fill=1, stroke=0)
    canvas.setFillColor(colors.HexColor('#99F6E4'))
    canvas.setFont('Helvetica', 8)
    canvas.drawString(20*mm, 6, 'Custom Sorting & Advanced Map Concepts — TAP Academy Style Notes')
    canvas.drawRightString(PW-20*mm, 6, f'Page {doc.page}')
    canvas.setStrokeColor(ACCENT)
    canvas.setLineWidth(2)
    canvas.line(0, PH-4, PW, PH-4)
    canvas.restoreState()

def build_content(s):
    e = []

    # ── Section 1: The ClassCastException & Custom Sorting
    e += sec('1. Solution to ClassCastException: Custom Sorting', s)
    e += story_box([
        'Problem: When using TreeSet with custom objects like Employee, if you don\'t define '
        'how to sort them, Java throws a ClassCastException.',
        '',
        'Even if Employee implements Comparator, TreeSet might still be confused. '
        'The primary rule of Comparator is:',
        '**"The class being sorted (Employee) should NEVER implement the Comparator interface."**',
        '',
        'Instead, create separate classes for each sorting logic (e.g., SortByID, SortByName).'
    ], s)
    e += code_block([
        '// Separate class for Sorting by ID',
        'class SortByID implements Comparator<Employee> {',
        '    @Override',
        '    public int compare(Employee e1, Employee e2) {',
        '        Integer id1 = e1.getID();',
        '        return id1.compareTo(e2.getID());',
        '    }',
        '}',
        '',
        '// Main method usage:',
        'SortByID sid = new SortByID();',
        'TreeSet<Employee> set = new TreeSet<>(sid); // Passing Comparator object',
    ], s)
    e += tip_box([
        'Loose Coupling: The TreeSet accepts the Comparator interface (Parent), but we pass SortByID (Child).',
        'This follows the rule of polymorphism where the interface promotes loose coupling.'
    ], s)
    e.append(PageBreak())

    # ── Section 2: Dynamic Sorting (Choice Based)
    e += sec('2. The Amazon Style Choice: Dynamic Sorting', s, PURPLE)
    e += story_box([
        'Imagine Amazon: you choose to sort by Price High-to-Low or Rating.',
        'Each choice corresponds to a different Comparator object created at runtime.'
    ], s)
    e += code_block([
        'Comparator<Employee> logic = null;',
        'System.out.println("Enter choice (1=ID, 2=Name): ");',
        'int choice = scan.nextInt();',
        '',
        'if(choice == 1) logic = new SortByID();',
        'else if(choice == 2) logic = new SortByName();',
        '',
        'TreeSet<Employee> set = new TreeSet<>(logic);',
    ], s)
    e += iptr([
        'Interview Tip: "Why Comparator over Comparable?"',
        'Answer: Because Comparable is natural sorting (one logic), but Comparator is custom sorting (unlimited logic).',
        'Custom sorting allows the program to adapt dynamically to user choices without modifying the data class.'
    ], s)
    e.append(PageBreak())

    # ── Section 3: Identity & Weak HashMaps
    e += sec('3. IdentityHashMap vs WeakHashMap', s, TEAL)
    e += diff_table(
        ['Map Type', 'Comparison Logic', 'Garbage Collection Behavior'],
        [
            ['HashMap', 'Uses .equals() (Value base)', 'Strong reference; keeps objects until map is cleared.'],
            ['IdentityHashMap', 'Uses == (Address base)', 'Treats keys as different if they have different addresses.'],
            ['WeakHashMap', 'Uses .equals()', 'Clears entries if the key has only one reference (Weak Reference).']
        ], s, col_w=[40*mm, 50*mm, 65*mm]
    )
    e += varbox([
        'Weak Reference Trick: An object with only one reference (from the map) is a Weak Reference.',
        'If you set original reference to null (s1 = null) and call System.gc(), WeakHashMap clears it.',
        'Exception: Strings in String Constant Pool (SCP) are never cleared by GC because they are for memory efficiency.'
    ], s)
    e += code_block([
        '// WeakHashMap Example',
        'WeakHashMap<String, Integer> map = new WeakHashMap<>();',
        'String s1 = new String("tap");',
        'map.put(s1, 1000);',
        's1 = null; // Key becomes weak reference',
        'System.gc(); // Invoking garbage collector',
        '// map will be empty now.'
    ], s)
    e.append(PageBreak())

    # ── Section 4: Legacy Classes
    e += sec('4. Legacy Classes: The Grandfather\'s Legacy', s, BLUE)
    e += story_box([
        'Java started in 1995. Collections Framework arrived in 1.2 (1997).',
        'Before Collections, programmers had "Legacy Classes". They are still in Java for "remembrance".'
    ], s)
    e += diff_table(
        ['Legacy Class', 'Modern Alternative', 'Thread-Safety'],
        [
            ['Vector', 'ArrayList', 'Synchronized (Thread-Safe)'],
            ['Hashtable', 'HashMap', 'Synchronized (Thread-Safe)'],
            ['Stack', 'ArrayDeque / LinkedList', 'Synchronized (Thread-Safe)'],
            ['Enumeration', 'Iterator', 'Not applicable']
        ], s
    )
    e += warn_box([
        'Don\'t use Legacy Classes in new projects! They are synchronized, making them much slower.',
        'Only use them if working on old "Legacy Apps" from the 90s.'
    ], s)
    e.append(PageBreak())

    # ── Section 5: The Biryani Analogy
    e += sec('5. The Biryani Philosophy of Collections', s, AMBER)
    e += story_box([
        'Why do we learn the user side of Collections first?',
        'Think of a Biryani. You go to a restaurant (Restaurant = Collections Framework).',
        '',
        'Your job as a hungry customer (Developer) is to LEARN HOW TO EAT it.',
        '  1. You don\'t need to know where the rice was grown (Source code/C++ logic).',
        '  2. You don\'t need to know the soil quality (Internal JVM memory).',
        '  3. You just need to know how to mix the raita and chicken (API usage).',
        '',
        'Collections are "Ready-to-Eat" data structures. Focus on knowing WHEN to use WHICH map/list.'
    ], s)
    e += iqa(1, "When should you use TreeSet with a Comparator?", [
        "Use it when you want custom, choice-based sorting of objects (like Amazon Filter), "
        "and you want to keep the sorting logic outside the original Data/POJO class."
    ], s)
    e += iqa(2, "Why are Legacy classes called Thread-Safe?", [
        "Because they are Synchronized. This means only one thread can access a method at a time. "
        "It prevents data corruption but makes execution very slow (like customers entering a room one by one)."
    ], s)

    e.append(PageBreak())
    e += sec('Cheat Sheet: Quick Recap', s)
    e += diff_table(
        ['Feature', 'Comparable', 'Comparator'],
        [
            ['Location', 'Inside the Class', 'Separate Class'],
            ['Method', 'compareTo(obj)', 'compare(obj1, obj2)'],
            ['Use Case', 'Natural Sorting', 'Custom Sorting'],
            ['Package', 'java.lang', 'java.util']
        ], s
    )

    return e

def build_pdf():
    filename = 'Java_Advanced_Collections_TAP_Academy.pdf'
    path = os.path.join(os.getcwd(), filename)
    doc = SimpleDocTemplate(
        path, pagesize=A4,
        leftMargin=25*mm, rightMargin=25*mm,
        topMargin=20*mm, bottomMargin=22*mm
    )
    s = make_styles()
    story = []
    story += build_cover(s)
    story += build_content(s)
    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    print(f'PDF saved: {path}')

if __name__ == "__main__":
    build_pdf()
