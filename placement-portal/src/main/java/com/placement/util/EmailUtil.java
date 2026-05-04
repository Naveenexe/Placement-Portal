package com.placement.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    private static final String FROM_EMAIL = "naveenwatare877@gmail.com";
    private static final String PASSWORD = "4thGearLuffy";

    public static void sendEmail(String toEmail, String studentName, String status) {

        Properties props = new Properties();

        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                    }
                });

        try {
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));

            message.setSubject("Placement Application Update");

            // 🔥 HTML MESSAGE DESIGN
            String htmlContent;

            if ("Selected".equals(status)) {

                htmlContent =
                        "<html>" +
                                "<body style='font-family:Arial;background:#f4f6f8;padding:20px;'>" +

                                "<div style='background:white;padding:20px;border-radius:10px;'>" +

                                "<h2 style='color:#2ecc71;'>🎉 Congratulations " + studentName + "!</h2>" +

                                "<p>You have been <b>SELECTED</b> for the placement process.</p>" +

                                "<p>We wish you success in your journey 🚀</p>" +

                                "<a href='http://localhost:8080/placement-portal' " +
                                "style='display:inline-block;padding:10px 15px;background:#3498db;color:white;text-decoration:none;border-radius:5px;'>"
                                + "Go to Dashboard</a>" +

                                "</div></body></html>";

            } else {

                htmlContent =
                        "<html>" +
                                "<body style='font-family:Arial;background:#f4f6f8;padding:20px;'>" +

                                "<div style='background:white;padding:20px;border-radius:10px;'>" +

                                "<h2 style='color:#e74c3c;'>Update on Your Application</h2>" +

                                "<p>Hello " + studentName + ",</p>" +

                                "<p>We regret to inform you that you were <b>not selected</b> this time.</p>" +

                                "<p>Keep improving and try again 💪</p>" +

                                "<a href='http://localhost:8080/placement-portal' " +
                                "style='display:inline-block;padding:10px 15px;background:#3498db;color:white;text-decoration:none;border-radius:5px;'>"
                                + "View Dashboard</a>" +

                                "</div></body></html>";
            }

            message.setContent(htmlContent, "text/html");

            Transport.send(message);

            System.out.println("Styled Email Sent Successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}