package com.spring.common.util;

import java.util.Properties;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.mail.javamail.JavaMailSender;

import com.spring.common.CommandMap;

public class MailSendUtil{
	private static PropertiesUtils propertiesUtils = new PropertiesUtils();
	
	public static void mailSend(JavaMailSender mailSender, CommandMap paramMap) throws Exception {
		MimeMessage mailMsg = mailSender.createMimeMessage();
		propertiesUtils.loadProp("/properties/app_config.properties");
		Properties properties = propertiesUtils.getProperties();
		
		mailMsg.setSubject("민원신고 처리가 완료되었습니다.");
		mailMsg.setContent(setMailInfo(paramMap), "text/html; charset=utf-8");
		mailMsg.setRecipient(RecipientType.TO, new InternetAddress((String) paramMap.get("email")));
		mailMsg.setFrom(new InternetAddress((String) paramMap.get("revEmail"),properties.getProperty("domin.name"),"UTF-8"));
		
		mailSender.send(mailMsg);
	}
	
	public final static String setMailInfo(CommandMap paramMap) throws Exception{
		StringBuffer mailContent = new StringBuffer();
		propertiesUtils.loadProp("/properties/app_config.properties");
		Properties properties = propertiesUtils.getProperties();
		
		mailContent.append("<html>");
		mailContent.append("<head>");
		mailContent.append("<meta http-equiv=Content-Type content=text/html; charset=utf-8>");
		mailContent.append("<title></title>");
		mailContent.append("<style type=text/css>");
		mailContent.append(".style1 {	color: #FF9933)");
		mailContent.append("	font-weight: bold;");
		mailContent.append("}");
		mailContent.append(".style3 {color: #FFFFFF}");
		mailContent.append("</style>");
		mailContent.append("</head>");
		mailContent.append("<body leftmargin=0 topmargin=0>");
		mailContent.append("<table width=590 height=672 border=0 cellpadding=0 cellspacing=0>");
		mailContent.append("<tr>");
		mailContent.append("	<td align=center valign=top background="+properties.getProperty("domin.nossl.url")+"/resources/css/images/mailing.gif>");
		mailContent.append("	<br><br><br><br><br><br><br><br>");
		mailContent.append("	<table width=90% border=0 cellpadding=0 cellspacing=2 bgcolor=#dcdcdc>");
		mailContent.append("    <tr>");
		mailContent.append("    	<td align=center bgcolor=#FFFFFF><br>");
		mailContent.append("        <br>");
		mailContent.append("        <table width=80% border=0 cellspacing=0 cellpadding=0>");
		mailContent.append("        <tr>");
		mailContent.append("            <td><span class=style1>불편 처리 완료</span></td>");
		mailContent.append("        </tr>");
		mailContent.append("		<tr>");
		mailContent.append("            <td>&nbsp;</td>");
		mailContent.append("        </tr>");
		mailContent.append("        <tr>");
		mailContent.append("            <td height=30> 불편 처리가 완료되었습니다.</td>");
		mailContent.append("        </tr>");
		mailContent.append("        <tr>");
		mailContent.append("            <td>불편 신고에 대한 처리 진행 결과가 아래와 같습니다.<br>");
		mailContent.append("            추후에도 신속한 조치를 약속드리며 더욱 노력하겠습니다.</td>");
		mailContent.append("        </tr>");
		mailContent.append("        <tr>");
		mailContent.append("            <td>&nbsp;</td>");
		mailContent.append("        </tr>");
		mailContent.append("        <tr>");
		mailContent.append("        	<td>");
		mailContent.append("			<table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor=#CCCCCC style=padding:4 0 0 20>");
		mailContent.append("            <tr>");
		mailContent.append("            	<td width=30% height=26 bgcolor=#6699CC><span class=style3>접수번호</span></td>");
		mailContent.append("            	<td width=70% bgcolor=#FFFFFF>" + paramMap.get("repair_no") + "</td>");
		mailContent.append("            </tr>");
		mailContent.append("            <tr>");
		mailContent.append("                <td height=26 bgcolor=#6699CC><span class=style3>처리결과</span></td>");
		mailContent.append("            	<td bgcolor=#FFFFFF>" + paramMap.get("repair_desc")  + "</td>");
		mailContent.append("            </tr>");
		mailContent.append("            </table>");
		mailContent.append("			</td>");
		mailContent.append("		</tr>");
		mailContent.append("        </table>");
		mailContent.append("        <br><br><br>");
		mailContent.append("		</td>");
		mailContent.append("	</tr>");
		mailContent.append("    </table>");
		mailContent.append("    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>");
		mailContent.append("	<table width=90% border=0 cellspacing=0 cellpadding=0>");
		mailContent.append("    <tr>");
		mailContent.append("    	<td align=right><a href="+properties.getProperty("domin.nossl.url")+" target=_blank><img src="+properties.getProperty("domin.nossl.url")+"/resources/css/images/logo.png border=0></a></td>");
		mailContent.append("    </tr>");
		mailContent.append("    </table>");
		mailContent.append("	</td>");
		mailContent.append("</tr>");
		mailContent.append("</table>");
		mailContent.append("</body>");
		mailContent.append("</html>");
		
		return mailContent.toString();
	}
}
