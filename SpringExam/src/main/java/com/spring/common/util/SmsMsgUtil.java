package com.spring.common.util;

import java.util.Properties;

import com.spring.common.CommandMap;

public class SmsMsgUtil {
	public static String setSmsMsg(CommandMap paramMap) throws Exception {
		PropertiesUtils propertiesUtils = new PropertiesUtils();
		propertiesUtils.loadProp("/properties/app_config.properties");
		Properties properties = propertiesUtils.getProperties();
		
		String prefix = "[".concat(properties.getProperty("domin.name"));
		String suffix = "";
		String smsMsg = "";
		
		String progressStatus = (String) paramMap.get("progress_status");
		
		if("01".equals(progressStatus)) {
			if("1".equals(paramMap.get("ligth_gubun"))) {
				suffix = "보안등".concat("] 민원신고가 접수되었습니다.");
			}
			else if("2".equals(paramMap.get("ligth_gubun"))) {
				suffix = "가로등".concat("] 민원신고가 접수되었습니다.");
			}
			else {
				suffix = "분전함".concat("] 민원신고가 접수되었습니다.");
			}
		}
		else if("02".equals(progressStatus)) {
			suffix = "] 작업지시 - 민원인 : "+paramMap.get("notice_name")+", 연락처 : "+paramMap.get("mobile")+", 접수번호 : "+paramMap.get("repair_no").toString().trim();
		}
		else if("04".equals(progressStatus)) {
			suffix = "] 접수번호 - "+paramMap.get("repair_no").toString().trim()+"가 처리 완료되었습니다. "+properties.getProperty("domin.nossl.url")+" 에서 확인하세요.";
		}
		
		smsMsg = prefix.concat(suffix);
		System.out.println("### smsMsg : "+smsMsg);
		
		return smsMsg;
	}
}
