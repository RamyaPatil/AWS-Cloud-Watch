import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;


public class SendEmail

{

//public static void main(String [] args)
//
//{  
	public static void sendMail(String to, String subject, String body ) {
		
     String from = "cmpe283team08@gmail.com";
     String pass ="team08@cmpe283";

  //   String to = "sowmya.prakash1@gmail.com";
     String host = "smtp.gmail.com";

     Properties properties = System.getProperties();
   

	   properties.put("mail.smtp.starttls.enable", "true");
	   properties.put("mail.smtp.host", host);
	   properties.put("mail.smtp.user", from);
	   properties.put("mail.smtp.password", pass);
	   properties.put("mail.smtp.port", "587");
	   properties.put("mail.smtp.auth", "true");

	   Session session = Session.getDefaultInstance(properties);


   try{

      MimeMessage message = new MimeMessage(session);

      message.setFrom(new InternetAddress(from));

      message.addRecipient(Message.RecipientType.TO,

                               new InternetAddress(to));

      message.setSubject(subject);

      message.setText(body);

      Transport transport = session.getTransport("smtp");

      transport.connect(host, from, pass);

      transport.sendMessage(message, message.getAllRecipients());

      transport.close();

      System.out.println("Sent message successfully....");

   }catch (MessagingException mex) {

      mex.printStackTrace();

   }

}

}
