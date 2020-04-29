package com.spring.slight.complaint.service;

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
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}

	@Override
	public Map<String, Object> getComplaintDetail(CommandMap paramMap) throws Exception {
		return complaintDao.getComplaintDetail(paramMap);
	}

	
}
