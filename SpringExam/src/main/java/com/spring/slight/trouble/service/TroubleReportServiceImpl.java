package com.spring.slight.trouble.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.dao.SmsSendDao;
import com.spring.common.util.PropertiesUtils;
import com.spring.common.util.SmsMsgUtil;
import com.spring.slight.system.dao.SystemMemberDao;
import com.spring.slight.trouble.dao.TroubleReportDao;

@Service("TroubleReportService")
public class TroubleReportServiceImpl implements TroubleReportService{
	@Autowired
	private TroubleReportDao troubleReportDao;
	
	@Autowired
	private SmsSendDao smsSendDao;
	
	@Autowired
	private SystemMemberDao systemMemberDao;
	
	@Override
	public int insertTrobleReport(CommandMap paramMap) throws Exception {
		Calendar cal = Calendar.getInstance();
		
		String repair_no = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		String inform_method = (String) paramMap.get("inform_method");
		if("01".equals(inform_method)) {
			paramMap.put("mobile", paramMap.get("phone").toString());
			paramMap.put("phone", "");
		}
		else if("03".equals(inform_method)) {
			paramMap.put("phone", paramMap.get("phone").toString());
		}
		String location = (String) paramMap.get("address");
		
		paramMap.put("repair_no", repair_no);
		paramMap.put("progress_status", "01");
		paramMap.put("sati_rating", "00");
		paramMap.put("notice_date", cal.getTime());
		paramMap.put("modify_date", cal.getTime());
		paramMap.put("location", location);
		
		int resultCnt = troubleReportDao.insertTrobleReport(paramMap);
		
		if(resultCnt > 0 && "01".equals(inform_method)) {
			CommandMap smsMsg = new CommandMap();
			
			PropertiesUtils propertiesUtils = new PropertiesUtils();
			propertiesUtils.loadProp("/properties/app_config.properties");
			Properties properties = propertiesUtils.getProperties();
			smsMsg.put("memberId", properties.getProperty("domin.id"));
			Map<String, Object> companyInfo = systemMemberDao.getSystemMemberDetail(smsMsg);
			
			smsMsg.put("notice_name", paramMap.get("notice_name"));
			smsMsg.put("mobile", paramMap.get("mobile"));
			smsMsg.put("light_gubun", paramMap.get("light_gubun"));
			smsMsg.put("jisaNum", companyInfo.get("phone"));
			smsMsg.put("groupDomain", properties.getProperty("domin.groupDomain"));
			smsMsg.put("msg", SmsMsgUtil.setSmsMsg(paramMap));
			smsSendDao.insertSmsSend(smsMsg);
		}
		
		return resultCnt;
	}
	
}
