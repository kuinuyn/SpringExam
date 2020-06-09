package com.spring.slight.complaint.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
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
	
	private String key;
	private String seq;

	@Override
	public ResultUtil getComplaintList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = complaintDao.getComplaintCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		if(paramMap.get("orderNm") != null && !"".equals(paramMap.get("orderNm"))) {
			this.seq = paramMap.get("order").toString();
			if("접수번호".equals(paramMap.get("orderNm"))) {
				this.key = "repair_no";
			}
			else if("접수일".equals(paramMap.get("orderNm"))) {
				this.key = "notice_date";
			}
			
			paramMap.put("orderNm", this.key);
		}
		
		List<Map<String, Object>> list = complaintDao.getComplaintList(paramMap);
		
		if(this.key != null && !"".equals(this.key)) {
			Collections.sort(list, new Comparator<Map<String, Object>>() {
				@Override
				public int compare(Map<String, Object> o1, Map<String, Object> o2) {
					if("1".equals(seq)) {
						return o1.get(key).toString().compareTo(o2.get(key).toString());
					}
					else {
						return o2.get(key).toString().compareTo(o1.get(key).toString());
					}
					
				}
			});
		}
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultStatusList = complaintDao.getComplaintStatusCnt(paramMap);
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
		int resultCnt = 0;
		
		String progressStatus = (String) complaintDao.getComplaintStatus(paramMap).get("progress_status");
		
		if(!"01".equals(progressStatus)) {
			resultCnt = -2;
		}
		else {
			resultCnt = complaintDao.updateComplaint(paramMap);
		}
		
		return resultCnt;
	}

	@Override
	public int deleteComplaint(CommandMap paramMap) throws Exception {
		int resultCnt = 0;
		
		String progressStatus = (String) complaintDao.getComplaintStatus(paramMap).get("progress_status");
		
		if(!"01".equals(progressStatus)) {
			resultCnt = -2;
		}
		else {
			resultCnt = complaintDao.deleteComplaint(paramMap);
		}
		
		return resultCnt;
	}
	
}
