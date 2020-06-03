package com.spring.slight.trouble.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.slight.trouble.dao.TroubleReportDao;

@Service("TroubleReportService")
public class TroubleReportServiceImpl implements TroubleReportService{
	@Autowired
	private TroubleReportDao troubleReportDao;
	
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
		
		return troubleReportDao.insertTrobleReport(paramMap);
	}
	
}
