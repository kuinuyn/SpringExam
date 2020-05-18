package com.spring.slight.complaint.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.complaint.dao.ComplaintDao;

@Service("ComplaintService")
public class ComplaintServiceImpl implements ComplaintService{
	
	@Autowired
	private ComplaintDao complaintDao;

	@Override
	public ResultUtil getComplaintList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = complaintDao.getComplaintCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = complaintDao.getComplaintList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultStatusList = complaintDao.getComplaintStatisCnt(paramMap);
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		String progressStatus = "";
		int status01Cnt = 0;
		int status02Cnt = 0;
		int status03Cnt = 0;
		int status04Cnt = 0;
		int status05Cnt = 0;
		Calendar cal = Calendar.getInstance();
		String today = new SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		String noticeDate = "";
		for(Map<String, Object> map : resultStatusList) {
			progressStatus = (String) map.get("progress_status");
			noticeDate = (String) map.get("notice_date");
			
			status01Cnt += Integer.parseInt(String.valueOf(map.get("count")));
			if("01".equals(progressStatus)) {
				status02Cnt+= Integer.parseInt(String.valueOf(map.get("count")));
			}
			else if("02".equals(progressStatus) || "03".equals(progressStatus)) {
				status03Cnt+= Integer.parseInt(String.valueOf(map.get("count")));
			}
			else if("04".equals(progressStatus) || "05".equals(progressStatus)) {
				status04Cnt+= Integer.parseInt(String.valueOf(map.get("count")));
			}
			
			if(today.compareTo(noticeDate) == 0) {
				status05Cnt+= Integer.parseInt(String.valueOf(map.get("count")));
			}
		}
		
		resultMap.put("status01Cnt", status01Cnt);
		resultMap.put("status02Cnt", status02Cnt);
		resultMap.put("status03Cnt", status03Cnt);
		resultMap.put("status04Cnt", status04Cnt);
		resultMap.put("status05Cnt", status05Cnt);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}

	@Override
	public Map<String, Object> getComplaintDetail(CommandMap paramMap) throws Exception {
		return complaintDao.getComplaintDetail(paramMap);
	}

	@Override
	public String getComplaintRoleChk(CommandMap paramMap) throws Exception {
		return complaintDao.getComplaintRoleChk(paramMap);
	}

	@Override
	public int updateComplaint(CommandMap paramMap) throws Exception {
		return complaintDao.updateComplaint(paramMap);
	}
	
}
