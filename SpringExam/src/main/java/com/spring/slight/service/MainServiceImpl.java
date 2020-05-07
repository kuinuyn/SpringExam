package com.spring.slight.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.slight.complaint.dao.ComplaintDao;
import com.spring.slight.dao.MainDao;
import com.spring.slight.equipment.dao.EquipmentDao;
import com.spring.slight.repair.dao.RepairDao;

@Service("MainService")
public class MainServiceImpl implements MainService{
	@Autowired
	private MainDao mainDao;
	
	@Autowired
	private ComplaintDao complaintDao;
	
	@Autowired
	private RepairDao repairDao;
	
	@Override
	public Map<String, Object> getSummary(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		String searchType = (String) paramMap.get("searchType");
		
		Calendar cal = Calendar.getInstance();
		String endDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		
		
		if("1".equals(searchType)) {
			if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
				cal.add(Calendar.DATE, -6);
			}
			else {
				cal.set(Calendar.DAY_OF_WEEK, 2);
			}
		}
		else if("2".equals(searchType)){
			cal.set(Calendar.DAY_OF_MONTH, 1);
		}
		String stDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		
		paramMap.put("endDate", endDate);
		paramMap.put("stDate", stDate);
		
		paramList = mainDao.getSummary(paramMap);
		int totalCnt = 0;//종합 건수
		int status01Cnt = 0;//신고접수 건수
		int status02Cnt = 0;//작업지시 건수
		int status03Cnt = 0;//작업진행 건수
		int status04Cnt = 0;//보수완료 건수
		int lightTypeStatus01Cnt = 0;//등 신고접수 건수
		int lightTypeStatus02Cnt = 0;//등 작업지시 건수
		int lightTypeStatus03Cnt = 0;//등 작업진행 건수
		int lightTypeStatus04Cnt = 0;//등 보수완료 건수
		String progressStatus = "";
		String lightType = "";
		String paramLightType = (String) paramMap.get("searchLightType");
		for(Map<String, Object> map : paramList) {
			progressStatus = (String) map.get("progress_status");
			lightType = (String) map.get("light_gubun");
			
			if("01".equals(progressStatus)) {
				status01Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			else if("02".equals(progressStatus)) {
				status02Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			else if("03".equals(progressStatus)) {
				status03Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			else if("04".equals(progressStatus)) {
				status04Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			
			if(paramLightType.equals(lightType)) {
				if("01".equals(progressStatus)) {
					lightTypeStatus01Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
				}
				else if("02".equals(progressStatus)) {
					lightTypeStatus02Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
				}
				else if("03".equals(progressStatus)) {
					lightTypeStatus03Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
				}
				else if("04".equals(progressStatus)) {
					lightTypeStatus04Cnt += Integer.parseInt(String.valueOf(map.get("cnt")));
				}
			}
		}
		
		totalCnt = status01Cnt+status02Cnt+status03Cnt+status04Cnt;
		
		resultMap.put("totalCnt", totalCnt);
		resultMap.put("status01Cnt", status01Cnt);
		resultMap.put("status02Cnt", status02Cnt);
		resultMap.put("status03Cnt", status03Cnt);
		resultMap.put("status04Cnt", status04Cnt);
		resultMap.put("lightTypeStatus01Cnt", lightTypeStatus01Cnt);
		resultMap.put("lightTypeStatus02Cnt", lightTypeStatus02Cnt);
		resultMap.put("lightTypeStatus03Cnt", lightTypeStatus03Cnt);
		resultMap.put("lightTypeStatus04Cnt", lightTypeStatus04Cnt);
		
		return resultMap;
	}

	@Override
	public Map<String, Object> getLastSummary() throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		
		Calendar cal = Calendar.getInstance();
		String endDate = new SimpleDateFormat("yyyyMM").format(cal.getTime());
		cal.add(Calendar.DATE, -1);
		String yesterday = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		
		cal.add(Calendar.DATE, 1);
		cal.add(Calendar.MONTH, -1);
		String stDate = new SimpleDateFormat("yyyyMM").format(cal.getTime());
		
		cal.add(Calendar.MONTH, 1);
		if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
			cal.add(Calendar.DATE, -6);
		}
		else {
			cal.set(Calendar.DAY_OF_WEEK, 2);
			cal.add(Calendar.DATE, -7);
		}
		String lastWeekSDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		
		cal.add(Calendar.DATE, 6);
		String lastWeekEDate = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		
		paramMap.put("endDate", endDate);
		paramMap.put("stDate", stDate);
		
		paramList = mainDao.getLastSummary(paramMap);
		
		int lastMonthCnt = 0;
		int lastWeekCnt = 0;
		int yesterdayCnt = 0;
		String notieDate = "";
		for(Map<String, Object> map : paramList) {
			cal.setTime(new SimpleDateFormat("yyyyMMdd").parse((String) map.get("notice_date")));
			notieDate = new SimpleDateFormat("yyyyMM").format(cal.getTime());
			if(stDate.compareTo(notieDate) == 0) {
				lastMonthCnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			
			notieDate = (String) map.get("notice_date");
			if(lastWeekSDate.compareTo(notieDate) <= 0 && lastWeekEDate.compareTo(notieDate) >= 0) {
				lastWeekCnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
			
			if(yesterday.compareTo(notieDate) == 0) {
				yesterdayCnt += Integer.parseInt(String.valueOf(map.get("cnt")));
			}
		}
		
		CommandMap commandMap = new CommandMap();
		commandMap.put("limit", 3);
		commandMap.put("offset", 0);
		List<Map<String, Object>> complaintList = complaintDao.getComplaintList(commandMap);
		List<Map<String, Object>> repairList = repairDao.getSystemRepairList(commandMap);
		
		resultMap.put("complaintList", complaintList);
		resultMap.put("repairList", repairList);
		
		resultMap.put("lastMonthCnt", lastMonthCnt);
		resultMap.put("lastWeekCnt", lastWeekCnt);
		resultMap.put("yesterdayCnt", yesterdayCnt);
		
		return resultMap;
	}

	@Override
	public int getLightCnt(CommandMap paramMap) throws Exception {
		
		return mainDao.getLightCnt(paramMap);
	}
	
}
