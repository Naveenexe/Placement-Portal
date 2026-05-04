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
ACCENT   = colors.HexColor("#0D9488")   # teal-600
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
    s['bul'] = ParagraphStyle('bul', fontName='Helvetica',      fontSize=10.5, textColor=GRAY_D, leading=17, leftIndent=18, spaceBefore=2, spaceAfter=2)
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

def sub(t, s): return [Paragraph(t, s['sub']), Spacer(1,2)]
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

def info_box(paras, s, color=TEAL, bg=TEAL_L):
    content = [Paragraph(p, s['cb']) for p in paras]
    t = Table([[content]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),bg),('LINEBEFORE',(0,0),(0,-1),4,color),
        ('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),14),('RIGHTPADDING',(0,0),(-1,-1),12),
    ]))
    return [t, Spacer(1,8)]

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
        Paragraph('COLLECTIONS FRAMEWORK', s['ct']),
        Paragraph('Comparator Interface, Descending Sort &amp; Real-World Sorting — TAP Academy', s['cs']),
        Spacer(1,4*mm), HR(colors.HexColor('#99F6E4'),2), Spacer(1,4*mm),
        Paragraph('Story-First &bull; Code + Trace &bull; Interview Ready &bull; TAP Academy Style', s['ctg']),
        Spacer(1,14*mm),
    ]
    t = Table([[inner]], colWidths=[155*mm])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),DARK),
        ('TOPPADDING',(0,0),(-1,-1),0),('BOTTOMPADDING',(0,0),(-1,-1),0),
        ('LEFTPADDING',(0,0),(-1,-1),20),('RIGHTPADDING',(0,0),(-1,-1),20),
    ]))
    items.append(t); items.append(Spacer(1,8*mm))
    tags = ['Comparator Interface','compare() method','Descending Sort x-1','Multi-field Sort',
            'TreeSet + Comparable','Scanner Input','Integer vs int in compare','Comparable vs Comparator',
            'Amazon Sort Demo','Objects.equals()']
    for row in [tags[:5], tags[5:]]:
        row_items = []
        for tag in row:
            td = [[Paragraph(tag, ParagraphStyle('tg', fontName='Courier-Bold', fontSize=7.5,
                    textColor=ACCENT, leading=12, alignment=TA_CENTER))]]
            tt = Table(td, colWidths=[29*mm])
            tt.setStyle(TableStyle([
                ('BACKGROUND',(0,0),(-1,-1),ACCENT_L),
                ('TOPPADDING',(0,0),(-1,-1),4),('BOTTOMPADDING',(0,0),(-1,-1),4),
                ('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),
            ]))
            row_items.append(tt)
        while len(row_items) < 5:
            row_items.append(Spacer(29*mm,1))
        tr = Table([row_items], colWidths=[31*mm]*5, hAlign='CENTER')
        tr.setStyle(TableStyle([('TOPPADDING',(0,0),(-1,-1),3),('BOTTOMPADDING',(0,0),(-1,-1),3)]))
        items.append(tr)
    items.append(PageBreak())
    return items

def build_toc(s):
    items = []
    items += sec('Table of Contents', s)
    entries = [
        ('1',  'Multi-field Comparable — Completed Code with Bug Fix'),
        ('2',  'The Integer Object Bug — == vs .equals() for Wrapper Classes'),
        ('3',  'TreeSet with Complex Objects and Comparable'),
        ('4',  'Duplicate Removal in TreeSet with Comparable'),
        ('5',  'Taking Employee Input from Scanner — Complete Program'),
        ('6',  'Descending Sort — The ×(-1) Trick'),
        ('7',  'Sort by Name, Length of Name in Descending Order'),
        ('8',  'The Problem with Comparable — One Compare at a Time'),
        ('9',  'Amazon Sort Demo — Why Comparable is Insufficient'),
        ('10', 'Comparator Interface — The Solution'),
        ('11', 'compare() vs compareTo() — Key Differences'),
        ('12', 'Why the Sorted Class Should NOT Implement Comparator'),
        ('13', 'Comparable vs Comparator — Complete Comparison'),
        ('14', 'Interview Questions — Deep Answers'),
        ('15', 'Cheat Sheet and Quick Reference'),
    ]
    for num, title in entries:
        row = [[Paragraph(num, s['ton']), Paragraph(title, s['toc'])]]
        t = Table(row, colWidths=[12*mm,143*mm])
        t.setStyle(TableStyle([
            ('TOPPADDING',(0,0),(-1,-1),4),('BOTTOMPADDING',(0,0),(-1,-1),4),
            ('LEFTPADDING',(0,0),(-1,-1),4),
        ]))
        items.append(t)
        items.append(HR(colors.HexColor('#E5E7EB'),0.5))
    items.append(PageBreak())
    return items

def on_page(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(DARK)
    canvas.rect(0, 0, PW, 18, fill=1, stroke=0)
    canvas.setFillColor(colors.HexColor('#99F6E4'))
    canvas.setFont('Helvetica', 8)
    canvas.drawString(20*mm, 6, 'Comparator, Descending Sort & Real-World Sorting — TAP Academy Style Notes')
    canvas.drawRightString(PW-20*mm, 6, f'Page {doc.page}')
    canvas.setStrokeColor(ACCENT)
    canvas.setLineWidth(2)
    canvas.line(0, PH-4, PW, PH-4)
    canvas.restoreState()

def build_content(s):
    e = []

    # ── Section 1: Multi-field Comparable complete
    e += sec('1. Multi-field Comparable — Completed Code with Bug Fix', s, ACCENT)
    e.append(body_p(
        'The previous class left you with an assignment: sort employees first by salary, '
        'then by name if salaries equal, then by ID if names also equal. '
        'Here is the complete corrected code with the critical bug explained.', s))
    e += code_block([
        '// Employee class implementing Comparable<Employee>',
        '// Sort: primary=salary, secondary=name, tertiary=ID',
        '',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Employee e1 = this;',
        '    Employee e2 = other;',
        '',
        '    // ── Primary: compare by salary ────────────────────────',
        '    Integer salary1 = e1.salary;   // autoboxing int → Integer',
        '    Integer salary2 = e2.salary;',
        '',
        '    // BUG: salary1 == salary2 compares REFERENCES (addresses), not values!',
        '    // CORRECT: salary1.equals(salary2) compares VALUES',
        '    if (salary1.equals(salary2)) {',
        '',
        '        // ── Secondary: salaries equal → compare by name ───',
        '        String name1 = e1.name;',
        '        String name2 = e2.name;',
        '',
        '        if (name1.equals(name2)) {',
        '',
        '            // ── Tertiary: names equal → compare by ID ──────',
        '            // ID is int (primitive) → autobox to Integer for compareTo',
        '            Integer id1 = e1.id;',
        '            return id1.compareTo(e2.id);',
        '',
        '        } else {',
        '            return name1.compareTo(name2);   // names differ',
        '        }',
        '',
        '    } else {',
        '        return salary1.compareTo(salary2);   // salaries differ',
        '    }',
        '}',
    ], s)
    e.append(PageBreak())

    # ── Section 2: The Integer Object Bug
    e += sec('2. The Integer Object Bug — == vs .equals() for Wrapper Classes', s, TEAL)
    e += story_box([
        'This is one of the most common bugs in Java — and one of the most common interview questions.',
        '',
        'You have Integer salary1 = 50000 and Integer salary2 = 50000.',
        'Both have the same VALUE. Are they equal?',
        '',
        'If you write: salary1 == salary2',
        '  This compares REFERENCES (memory addresses).',
        '  salary1 and salary2 are two different Integer objects in heap.',
        '  They have DIFFERENT addresses.',
        '  Result: false — even though values are same!',
        '',
        'If you write: salary1.equals(salary2)',
        '  This compares VALUES via the overridden equals() method in Integer.',
        '  50000 == 50000 → true. Correct!',
        '',
        'RULE: For primitive types (int, double), use == for comparison.',
        'For wrapper/object types (Integer, Double, String), ALWAYS use .equals() for value comparison.',
        '',
        'Exception to remember: Java caches Integer values from -128 to 127.',
        'For values in that range, == happens to work because same object is reused.',
        'For values outside that range (like 50000), == gives wrong result.',
        'ALWAYS use .equals() to be safe.',
    ], s)
    e += diff_table(
        ['Type', 'Use == for?', 'Use .equals() for?'],
        [
            ['int (primitive)', 'Value comparison — always safe', 'Not applicable — no .equals() on primitive'],
            ['Integer (wrapper)', 'Reference comparison only', 'Value comparison — ALWAYS use this'],
            ['String', 'Reference comparison (almost never useful)', 'Value comparison — ALWAYS use this'],
            ['Custom objects', 'Reference check (same object?)', 'Value comparison — after overriding equals()'],
        ],
        s, col_w=[35*mm, 55*mm, 65*mm]
    )
    e += warn_box([
        'Integer sal1 = 50000; Integer sal2 = 50000; sal1 == sal2 → FALSE (different objects).',
        'Always use .equals() when comparing Integer, Double, String, or any wrapper/object type.',
        'int a = 50000; int b = 50000; a == b → TRUE (primitives — direct value comparison).',
        'The problem in compareTo: salary1 == salary2 compares addresses → always false → sort broken.',
    ], s)
    e.append(PageBreak())

    # ── Section 3: TreeSet with Comparable
    e += sec('3. TreeSet with Complex Objects and Comparable', s, ACCENT)
    e += story_box([
        'You already know: TreeSet sorts automatically. No need to call Collections.sort().',
        '',
        'But how does TreeSet sort? Same chain:',
        '  TreeSet adds element → internally calls sort → sort calls compareTo.',
        '',
        'So: if your custom class implements Comparable and overrides compareTo,',
        'TreeSet will automatically sort your objects using that logic.',
        '',
        'If compareTo is NOT available → ClassCastException when adding to TreeSet.',
        '',
        'This is why implementing Comparable makes your class work with BOTH:',
        '  Collections.sort(list) — for ArrayList sorting',
        '  TreeSet              — for automatic sorted storage',
    ], s)
    e += code_block([
        '// Employee implements Comparable<Employee> with compareTo() defined',
        '',
        '// Using TreeSet — no need to call Collections.sort():',
        'TreeSet<Employee> set = new TreeSet<>();',
        'set.add(new Employee(2, "Sundar", 60000));',
        'set.add(new Employee(1, "Tim",    50000));',
        'set.add(new Employee(3, "Alex",   35000));',
        '',
        'System.out.println(set);',
        '// Output: sorted automatically based on compareTo() logic',
        '// If sorted by salary: [3 Alex 35000, 1 Tim 50000, 2 Sundar 60000]',
        '',
        '// Compare with ArrayList — must call sort explicitly:',
        'ArrayList<Employee> list = new ArrayList<>();',
        'list.add(new Employee(2, "Sundar", 60000));',
        'list.add(new Employee(1, "Tim",    50000));',
        'System.out.println(list);   // NOT sorted yet',
        'Collections.sort(list);',
        'System.out.println(list);   // NOW sorted',
        '',
        '// WITHOUT Comparable → ClassCastException:',
        '// TreeSet<Employee> set2 = new TreeSet<>();',
        '// set2.add(new Employee(1, "Tim", 50000));  ← ClassCastException!',
    ], s)
    e.append(PageBreak())

    # ── Section 4: Duplicate Removal in TreeSet
    e += sec('4. Duplicate Removal in TreeSet with Comparable', s, TEAL)
    e += story_box([
        'TreeSet is a Set — it rejects duplicates. But how does it know if two Employee '
        'objects are duplicates?',
        '',
        'It uses compareTo()! When compareTo() returns ZERO for two objects, '
        'TreeSet treats them as EQUAL (duplicates) and does NOT add the second one.',
        '',
        'So your compareTo() logic ALSO controls what is considered a duplicate in TreeSet.',
        '',
        'If your compareTo() compares by salary → name → ID:',
        '  Two employees with same salary + name + ID → compareTo returns 0 → DUPLICATE → rejected.',
        '  Two employees with same salary + name but different ID → compareTo returns non-zero → UNIQUE → both stored.',
        '',
        'This is why implementing Comparable correctly also handles deduplication in TreeSet.',
        '',
        'ArrayList: always stores both (no duplicate check ever).',
        'TreeSet: rejects anything where compareTo returns 0.',
    ], s)
    e += code_block([
        '// DUPLICATE TEST in TreeSet:',
        'TreeSet<Employee> set = new TreeSet<>();',
        'set.add(new Employee(1, "Tim", 50000));',
        'set.add(new Employee(1, "Tim", 50000));   // exact duplicate',
        'System.out.println(set.size());   // 1 — duplicate removed!',
        '',
        '// SAME salary+name, DIFFERENT ID:',
        'set.add(new Employee(2, "Tim", 50000));   // same salary+name, id=2',
        'System.out.println(set.size());   // 2 — NOT duplicate (ID differs)',
        '',
        '// ARRAYLIST: always stores both, no dedup:',
        'ArrayList<Employee> list = new ArrayList<>();',
        'list.add(new Employee(1, "Tim", 50000));',
        'list.add(new Employee(1, "Tim", 50000));',
        'System.out.println(list.size());   // 2 — both stored',
        '',
        '// DECISION GUIDE:',
        '// Duplicates allowed → ArrayList (or LinkedList)',
        '// No duplicates, sorted → TreeSet + Comparable',
        '// No duplicates, unsorted → HashSet + hashCode/equals',
    ], s)
    e.append(PageBreak())

    # ── Section 5: Scanner Input Program
    e += sec('5. Taking Employee Input from Scanner — Complete Program', s, PURPLE)
    e.append(body_p(
        'Real applications take input from users, not hardcoded values. '
        'This program takes N employees as comma-separated input and sorts them.', s))
    e += code_block([
        'import java.util.Scanner;',
        'import java.util.TreeSet;',
        '// Assumes Employee implements Comparable<Employee>',
        '',
        'Scanner scan = new Scanner(System.in);',
        '',
        'System.out.println("Enter number of employees:");',
        'int n = scan.nextInt();',
        '',
        '// CRITICAL: Clear the newline buffer after nextInt()',
        '// nextInt() reads the number but leaves "\\n" in the buffer.',
        '// nextLine() on the next call reads that \\n as empty string.',
        '// Fix: call scan.nextLine() ONCE after nextInt() to flush the buffer.',
        'scan.nextLine();   // flush buffer — put OUTSIDE the loop',
        '',
        'TreeSet<Employee> set = new TreeSet<>();',
        '',
        'System.out.println("Enter employee details (format: id,name,salary):");',
        'for (int i = 1; i <= n; i++) {',
        '    String empDetail = scan.nextLine();           // "1,Tim,50000"',
        '    String[] empArray = empDetail.split(",");     // ["1","Tim","50000"]',
        '',
        '    // Short form — no intermediate variables:',
        '    set.add(new Employee(',
        '        Integer.parseInt(empArray[0]),   // id',
        '        empArray[1],                      // name (already String)',
        '        Integer.parseInt(empArray[2])    // salary',
        '    ));',
        '}',
        '',
        'System.out.println(set);',
        '',
        '// SAMPLE RUN:',
        '// Enter number of employees: 3',
        '// Enter employee details (format: id,name,salary):',
        '// 1,Tim,50000',
        '// 2,Sundar,40000',
        '// 3,Alex,35000',
        '// Output: [3 Alex 35000, 2 Sundar 40000, 1 Tim 50000]  (sorted by salary)',
    ], s)
    e += warn_box([
        'scan.nextLine() after scan.nextInt() is mandatory — clears the newline buffer.',
        'If placed inside the loop, it would consume actual employee data as the flush.',
        'Integer.parseInt() for id/salary — they come as String from split(), need conversion.',
        'name is already String — no conversion needed.',
    ], s)
    e.append(PageBreak())

    # ── Section 6: Descending Sort — ×(-1) Trick
    e += sec('6. Descending Sort — The ×(-1) Trick', s, ACCENT)
    e += story_box([
        'By default, compareTo() sorts in ASCENDING order.',
        '',
        'How does sorting work? compareTo() returns positive, negative, or zero.',
        '  Positive → sort() swaps (bigger element moves right)',
        '  Negative → no swap',
        '  Zero → no swap',
        '',
        'To reverse: make positive become negative and negative become positive.',
        'Multiplying by -1 achieves this.',
        '',
        'Proof: Comparing 100 and 50:',
        '  Ascending: 100.compareTo(50) = positive → swap → 50 comes first.',
        '  Descending: 100.compareTo(50) * -1 = negative → no swap → 100 stays first.',
        '',
        'Proof: Comparing 50 and 100:',
        '  Ascending: 50.compareTo(100) = negative → no swap → 50 first (correct for ascending).',
        '  Descending: 50.compareTo(100) * -1 = positive → swap → 100 comes first (correct for descending).',
        '',
        'This works for ANY field — salary, name, length, anything compareTo returns.',
    ], s)
    e += code_block([
        '// ASCENDING order (default):',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Integer sal1 = this.salary;',
        '    return sal1.compareTo(other.salary);',
        '    // Result: [35000, 50000, 60000, 85000] → low to high',
        '}',
        '',
        '// DESCENDING order — multiply by -1:',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Integer sal1 = this.salary;',
        '    return sal1.compareTo(other.salary) * -1;',
        '    // Result: [85000, 60000, 50000, 35000] → high to low',
        '}',
        '',
        '// ALTERNATIVE syntax (same result):',
        '    return -(sal1.compareTo(other.salary));',
        '',
        '// DESCENDING for name (alphabetical reverse):',
        '@Override',
        'public int compareTo(Employee other) {',
        '    return this.name.compareTo(other.name) * -1;',
        '    // Sundar before Tim before Alex... reversed alphabetical',
        '}',
        '',
        '// DESCENDING for name LENGTH:',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Integer len1 = this.name.length();',
        '    return len1.compareTo(other.name.length()) * -1;',
        '    // Longer names first: "Sundar"(6) > "Charlie"(7)?',
        '    // Wait: "Charlie"=7 > "Sundar"=6 > "Bob"=3 in descending',
        '}',
    ], s)
    e += tip_box([
        'Descending = multiply compareTo result by -1. Flip the sign of what compareTo returns.',
        'Works for any data type: salary, name, length, date, rating, price — all use same trick.',
        'You can also negate: -(sal1.compareTo(sal2)) is same as sal1.compareTo(sal2) * -1.',
        'Amazon high-to-low price sort = compareTo * -1. Zomato highest-rated first = same trick.',
    ], s)
    e.append(PageBreak())

    # ── Section 7: Sort by Name, Length
    e += sec('7. Sort by Name and by Name Length — Examples', s, TEAL)
    e += code_block([
        '// Employees: Tim, Sundar, Alex, Charlie, Bob',
        '',
        '// ── Sort by NAME ascending (alphabetical) ──────────────',
        '@Override',
        'public int compareTo(Employee other) {',
        '    return this.name.compareTo(other.name);',
        '    // Alex < Bob < Charlie < Sundar < Tim (A→Z)',
        '}',
        '',
        '// ── Sort by NAME descending (reverse alphabetical) ─────',
        '@Override',
        'public int compareTo(Employee other) {',
        '    return this.name.compareTo(other.name) * -1;',
        '    // Tim > Sundar > Charlie > Bob > Alex (Z→A)',
        '}',
        '',
        '// ── Sort by NAME LENGTH ascending ───────────────────────',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Integer len1 = this.name.length();   // autoboxing',
        '    return len1.compareTo(other.name.length());',
        '    // Bob(3) < Alex(4) < Sundar(6) < Charlie(7)',
        '}',
        '',
        '// ── Sort by NAME LENGTH descending ──────────────────────',
        '@Override',
        'public int compareTo(Employee other) {',
        '    Integer len1 = this.name.length();',
        '    return len1.compareTo(other.name.length()) * -1;',
        '    // Charlie(7) > Sundar(6) > Alex(4) > Bob(3)',
        '}',
        '',
        '// KEY PATTERN: Whatever field you want to sort by,',
        '// call compareTo on the WRAPPER of that field.',
        '// Add * -1 for descending.',
    ], s)
    e.append(PageBreak())

    # ── Section 8: Problem with Comparable
    e += sec('8. The Problem with Comparable — One Compare at a Time', s, ACCENT)
    e += story_box([
        'Comparable has a critical limitation: you can only have ONE compareTo() per class.',
        '',
        'If your compareTo sorts by salary, you cannot simultaneously also sort by name.',
        'To change the sort criterion, you must DELETE the current code and RETYPE new code.',
        '',
        'In a real application, you never want to modify the class just to change how it sorts.',
        '',
        'Example problem:',
        '  You have a product class with: name, price, rating, date, numOrders.',
        '  Amazon allows sorting by: price low-high, price high-low, rating, newest, bestseller.',
        '  That is 5 different sort modes.',
        '',
        'With Comparable: you can only encode ONE sort mode in the class.',
        'Changing the sort mode = modifying the Product class = bad design.',
        '',
        'The solution: Comparator interface — a SEPARATE interface that holds the sort logic '
        'OUTSIDE the class being sorted. Multiple Comparators can exist for the same class.',
    ], s)
    e.append(PageBreak())

    # ── Section 9: Amazon Sort Demo
    e += sec('9. Amazon Sort Demo — Why Comparable is Insufficient', s, TEAL)
    e += story_box([
        'Open Amazon. Search for "Samsung phone". Click "Sort by" at the top right.',
        '',
        'Options you see:',
        '  Featured (sponsored rank)',
        '  Price: Low to High',
        '  Price: High to Low',
        '  Avg. Customer Review',
        '  Newest Arrivals',
        '  Best Sellers',
        '',
        'Each of these is a DIFFERENT sort criterion on the SAME Product objects.',
        '',
        'With Comparable:',
        '  You can implement ONE compareTo() in Product class.',
        '  Choose: sort by price ascending.',
        '  User clicks "Price: High to Low" → you need to change the class → impossible at runtime.',
        '',
        'With Comparator:',
        '  Create PriceAscComparator, PriceDescComparator, RatingComparator, DateComparator etc.',
        '  Each is a SEPARATE class implementing Comparator.',
        '  At runtime, pass the appropriate Comparator to Collections.sort().',
        '  Product class stays unchanged.',
        '',
        'This is the core design difference: Comparable = one permanent sort. '
        'Comparator = multiple flexible sorts.',
    ], s)
    e.append(PageBreak())

    # ── Section 10: Comparator Interface
    e += sec('10. Comparator Interface — The Solution', s, ACCENT)
    e.append(body_p(
        'Comparator is a functional interface in java.util package. '
        'It has ONE abstract method: compare(T o1, T o2). '
        'Unlike compareTo() which takes ONE parameter (other comes from this), '
        'compare() takes TWO parameters — both objects are explicitly provided.', s))
    e += code_block([
        '// Comparator interface (java.util):',
        'public interface Comparator<T> {',
        '    int compare(T o1, T o2);  // both objects passed explicitly',
        '    // Also has default methods: reversed(), thenComparing() etc.',
        '}',
        '',
        '// Creating a Comparator for Employee sorted by salary:',
        '',
        '// APPROACH 1: Separate named class',
        'class SalaryComparator implements Comparator<Employee> {',
        '    @Override',
        '    public int compare(Employee e1, Employee e2) {',
        '        Integer sal1 = e1.getSalary();',
        '        return sal1.compareTo(e2.getSalary());',
        '    }',
        '}',
        '',
        '// APPROACH 2: Anonymous class (older style)',
        'Comparator<Employee> bySalary = new Comparator<Employee>() {',
        '    @Override',
        '    public int compare(Employee e1, Employee e2) {',
        '        return Integer.compare(e1.getSalary(), e2.getSalary());',
        '    }',
        '};',
        '',
        '// APPROACH 3: Lambda (modern, preferred)',
        'Comparator<Employee> bySalary = (e1, e2) ->',
        '    Integer.compare(e1.getSalary(), e2.getSalary());',
        '',
        '// Using the Comparator:',
        'Collections.sort(list, bySalary);   // pass comparator as second argument',
        '',
        '// Multiple comparators — no class modification needed:',
        'Comparator<Employee> byName    = (e1, e2) -> e1.getName().compareTo(e2.getName());',
        'Comparator<Employee> byNameLen = (e1, e2) -> e1.getName().length() - e2.getName().length();',
        '',
        'Collections.sort(list, byName);     // sort by name',
        'Collections.sort(list, byNameLen);  // sort by name length — same list, different sort',
    ], s)
    e.append(PageBreak())

    # ── Section 11: compare() vs compareTo()
    e += sec('11. compare() vs compareTo() — Key Differences', s, TEAL)
    e += diff_table(
        ['Aspect', 'compareTo() (Comparable)', 'compare() (Comparator)'],
        [
            ['Interface', 'java.lang.Comparable<T>', 'java.util.Comparator<T>'],
            ['Method signature', 'int compareTo(T other)', 'int compare(T o1, T o2)'],
            ['Parameters', 'ONE — the other object. "this" is first.', 'TWO — both objects explicit'],
            ['Where implemented', 'INSIDE the class being sorted (Employee)', 'OUTSIDE the class — separate class/lambda'],
            ['Number of sorts possible', 'ONE per class (one compareTo)', 'UNLIMITED — one Comparator per sort type'],
            ['Modifying original class', 'YES — class must implement Comparable', 'NO — original class unchanged'],
            ['Usage', 'Collections.sort(list)', 'Collections.sort(list, comparator)'],
            ['Best for', 'Natural/default ordering', 'Multiple sort criteria, flexible sorting'],
            ['Real example', 'Integer sorts numerically, String alphabetically', 'Amazon price sort, rating sort, date sort'],
        ],
        s, col_w=[35*mm, 60*mm, 60*mm]
    )
    e.append(PageBreak())

    # ── Section 12: Why not implement Comparator in the sorted class
    e += sec('12. Why the Sorted Class Should NOT Implement Comparator', s, PURPLE)
    e += story_box([
        'You CAN make Employee implement Comparator<Employee> and override compare().',
        'It compiles. It runs. But it defeats the entire purpose of Comparator.',
        '',
        'The whole reason Comparator exists is:',
        '  "Sort logic should be OUTSIDE the class so you can have MULTIPLE sort strategies '
        '  without modifying the class."',
        '',
        'If Employee implements Comparator, you are putting the logic back INSIDE Employee.',
        'You still have only one compare() in Employee.',
        'You gained nothing over Comparable.',
        '',
        'The correct pattern:',
        '  Create separate Comparator classes for each sort type.',
        '  Or use anonymous classes/lambdas inline.',
        '  The Employee class stays clean — no sorting logic inside it.',
        '',
        'Exception: Comparable IS correct inside Employee for defining the NATURAL ordering '
        '(the default sort order). If you only need one sort criteria ever, Comparable is fine.',
    ], s)
    e += iptr([
        '"What is the difference between Comparable and Comparator?" — most frequent Collections interview question.',
        'Comparable: inside class, one sort, natural ordering. Comparator: outside class, multiple sorts, flexible.',
        'When Comparator: "I need to sort by different criteria without changing the class."',
        'When Comparable: "This class has one natural sort order (Integer → ascending, String → alphabetical)."',
    ], s)
    e.append(PageBreak())

    # ── Section 13: Comparable vs Comparator
    e += sec('13. Comparable vs Comparator — Complete Comparison', s, ACCENT)
    e += diff_table(
        ['Point', 'Comparable', 'Comparator'],
        [
            ['Package', 'java.lang (no import)', 'java.util (must import)'],
            ['Method', 'compareTo(T other)', 'compare(T o1, T o2)'],
            ['Parameters', '1 (other)', '2 (both explicit)'],
            ['Implemented by', 'The class being sorted', 'A SEPARATE class/lambda'],
            ['Modifies original class?', 'YES — class implements Comparable', 'NO — original class unchanged'],
            ['Sorts per class', 'ONE (one compareTo)', 'UNLIMITED (one Comparator each)'],
            ['How to use', 'Collections.sort(list)', 'Collections.sort(list, comparator)'],
            ['Natural ordering', 'YES — defines default sort', 'NO — defines alternate sorts'],
            ['TreeSet usage', 'Works directly', 'Pass to TreeSet constructor: new TreeSet<>(comparator)'],
            ['Lambda friendly', 'No (class must implement)', 'YES — Comparator is functional interface'],
            ['Use case', 'One permanent sort criterion', 'Multiple dynamic sort options'],
        ],
        s, col_w=[35*mm, 60*mm, 60*mm]
    )
    e += code_block([
        '// TreeSet with Comparator (instead of Comparable):',
        'Comparator<Employee> bySalary = (e1, e2) ->',
        '    Integer.compare(e1.getSalary(), e2.getSalary());',
        '',
        '// Pass comparator to TreeSet constructor:',
        'TreeSet<Employee> set = new TreeSet<>(bySalary);',
        'set.add(new Employee(2, "Sundar", 60000));',
        'set.add(new Employee(1, "Tim",    50000));',
        '// Output: sorted by salary using the provided Comparator',
        '// Employee class does NOT need to implement Comparable!',
    ], s)
    e.append(PageBreak())

    # ── Section 14: Interview Q&A
    e += sec('14. Interview Questions — Deep Answers', s, PURPLE)

    e += iqa(1, 'What is the difference between Comparable and Comparator in Java?', [
        'This is the most frequently asked Collections interview question.',
        '',
        '**Comparable (java.lang):** An interface that the class itself implements to define its '
        'natural ordering. The class must override compareTo(T other) which takes one parameter. '
        '"this" is the first object, "other" is the second. Since the class implements Comparable, '
        'it is modified. Only ONE compareTo() per class — one permanent sort order.',
        '',
        '**Usage:** Collections.sort(list) — no second argument needed.',
        '',
        '**Comparator (java.util):** An interface implemented by a SEPARATE class or lambda '
        'to define alternate sort orderings. The method compare(T o1, T o2) takes TWO explicit '
        'parameters. The class being sorted is NOT modified. Multiple Comparators can exist for '
        'the same class — one per sort criterion.',
        '',
        '**Usage:** Collections.sort(list, comparator) — pass the Comparator as second argument.',
        '',
        '**When to use which:** Use Comparable when the class has ONE natural ordering that '
        'rarely changes (like Integer sorting numerically). Use Comparator when you need multiple '
        'sort options at runtime (like Amazon sorting products by price, rating, newest, bestseller — '
        'all different Comparators on the same Product class).',
        '',
        '**Key insight:** Comparator solves the problem that Comparable cannot — you cannot '
        'have two compareTo() methods in the same class, but you can have unlimited Comparators.',
    ], s)

    e += iqa(2, 'How do you sort a list of objects in descending order using Comparable?', [
        'By default, compareTo() sorts in ascending order because: when the current element is '
        'greater than the other, compareTo() returns positive, which causes sort() to swap — '
        'moving the smaller element before the larger. Result = ascending.',
        '',
        '**The -1 trick:** To reverse the order, multiply the compareTo() result by -1. '
        'This flips positive to negative and negative to positive:',
        '',
        'When current > other: compareTo returns positive → × -1 = negative → no swap → larger stays first.',
        'When current < other: compareTo returns negative → × -1 = positive → swap → larger moves first.',
        '',
        '**In code:** return sal1.compareTo(sal2) * -1;',
        '**Alternative:** return -(sal1.compareTo(sal2));',
        '',
        'This works for any data type: salary, name (reverse alphabetical), '
        'length, rating, price — just multiply any compareTo result by -1.',
        '',
        '**Same with Comparator:** (e1, e2) -> Integer.compare(e2.getSalary(), e1.getSalary()); '
        '(note e2 and e1 swapped — another way to achieve descending).',
    ], s)

    e += iqa(3, 'How do you sort custom objects with multiple criteria (e.g., by salary, then name)?', [
        'This requires multi-field compareTo() — a chain of comparisons. '
        'Check the primary field. If equal, check secondary. If equal, check tertiary.',
        '',
        '**Logic:** In compareTo(Employee other):',
        '1. Compare salaries using salary1.compareTo(salary2).',
        '2. If salary1.equals(salary2) (MUST use .equals() for Integer, not ==):',
        '   Compare names using name1.compareTo(name2).',
        '3. If name1.equals(name2):',
        '   Compare IDs using id1.compareTo(id2). (IDs always unique — final tiebreaker).',
        '4. If salaries differ: return salary comparison result.',
        '5. If names differ: return name comparison result.',
        '',
        '**Critical bug:** Using == for Integer comparison compares addresses, not values. '
        'Integer sal1 = 50000; Integer sal2 = 50000; sal1 == sal2 is FALSE because they are '
        'different objects. Always use sal1.equals(sal2) for wrapper class comparison.',
        '',
        '**Real-world equivalent:** Amazon sorts products by price → then by rating → '
        'then by number of reviews. Same multi-field pattern.',
    ], s)

    e += iqa(4, 'Why should the class being sorted NOT implement Comparator?', [
        'Comparator was introduced specifically to solve the limitation of Comparable: '
        '"What if I need multiple sort orders for the same class without modifying the class?"',
        '',
        '**The Comparable limitation:** One class can have only one compareTo(). '
        'If Employee implements Comparable and compareTo sorts by salary, you cannot '
        'also sort by name without changing the class.',
        '',
        '**Comparator solution:** Create separate Comparator classes (or lambdas) for each '
        'sort criterion. SalaryComparator, NameComparator, RatingComparator — all separate, '
        'none modifying Employee. Pass the right one to Collections.sort() at runtime.',
        '',
        '**If Employee implements Comparator:** You put the compare logic back inside Employee. '
        'You still have only one compare() in Employee. You gained nothing over Comparable. '
        'The separation of concerns is lost. The class is now responsible both for being an '
        'Employee (data) AND for knowing how to sort Employees (behavior) — mixed concerns.',
        '',
        '**Correct pattern:** Employee → define compareTo() for natural ordering (Comparable). '
        'For other sort modes → create SalaryAscComparator, SalaryDescComparator, NameComparator etc. '
        'as separate classes or lambdas. Employee class stays focused on data only.',
    ], s)
    e.append(PageBreak())

    # ── Section 15: Cheat Sheet
    e += sec('15. Cheat Sheet and Quick Reference', s, TEAL)
    e += diff_table(
        ['Term / Concept', 'One-Line Definition'],
        [
            ['Comparable', 'java.lang interface. Class implements it. compareTo(T other). ONE sort per class.'],
            ['Comparator', 'java.util interface. Separate class/lambda. compare(T o1, T o2). UNLIMITED sorts.'],
            ['compareTo()', 'Returns int: pos=swap(ascend), neg=no swap, zero=no swap.'],
            ['compare()', 'Same return convention. Takes TWO explicit params. Used with Comparator.'],
            ['Ascending (default)', 'return compareTo() result as-is.'],
            ['Descending trick', 'return compareTo() * -1. Flip the sign.'],
            ['Multi-field sort', 'Check primary. If .equals(), check secondary. If .equals(), check tertiary.'],
            ['== vs .equals() for Integer', '== compares addresses (WRONG for Integer). .equals() compares values (CORRECT).'],
            ['TreeSet + Comparable', 'TreeSet auto-sorts using compareTo(). No Collections.sort() needed.'],
            ['TreeSet + Comparator', 'Pass Comparator to constructor: new TreeSet<>(myComparator).'],
            ['Duplicate in TreeSet', 'compareTo() returns 0 → treated as duplicate → rejected.'],
            ['Scanner buffer fix', 'scan.nextLine() after scan.nextInt() to clear \\n from buffer. Outside loop.'],
            ['split(",")[0,1,2]', 'Parse CSV input: id=parseInt(arr[0]), name=arr[1], salary=parseInt(arr[2]).'],
            ['Lambda Comparator', '(e1, e2) -> Integer.compare(e1.getSalary(), e2.getSalary())'],
        ],
        s, col_w=[42*mm, 113*mm]
    )
    e += info_box([
        '&#128218; Next Topic: Remaining Map concepts + Collections Framework wrap-up.',
        '&#9998;  Practice: Write all 5 sort modes (salary asc/desc, name asc, length desc, multi-field) using Comparator.',
        '&#9998;  Practice: Create TreeSet with Comparator passed to constructor. No Comparable in Employee.',
        '&#127919;  Interview: "Comparable vs Comparator?" — guaranteed question. Know both in depth.',
        '&#11088;  Key: Comparable = natural ordering inside class. Comparator = flexible ordering outside class.',
        '&#128304;  Bug trap: Integer == Integer compares addresses. Use .equals() for value comparison.',
        '&#128304;  Descending = multiply by -1. Works for every compareTo return value.',
    ], s)
    return e

def build_pdf():
    # Saving to the same directory as the script
    filename = 'Java_Comparator_Sorting_TAP_Academy.pdf'
    path = os.path.join(os.getcwd(), filename)
    doc = SimpleDocTemplate(
        path, pagesize=A4,
        leftMargin=25*mm, rightMargin=25*mm,
        topMargin=20*mm, bottomMargin=22*mm
    )
    s = make_styles()
    story = []
    story += build_cover(s)
    story += build_toc(s)
    story += build_content(s)
    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    print(f'PDF saved: {path}')

if __name__ == "__main__":
    build_pdf()
