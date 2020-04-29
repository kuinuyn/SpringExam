package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.dao.RepairDao;

@Service("RepairService")
public class RepairServiceImpl implements RepairService{
	@Autowired
	private RepairDao repairDao;

	@Override
	public ResultUtil getSystemRepairList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = repairDao.getSystemRepairCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = repairDao.getSystemRepairList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}

	@Override
	public Map<String, Object> getSystemRepairDetail(CommandMap paramMap) throws Exception {
		return repairDao.getSystemRepairDetail(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSystemRepairExcelList(CommandMap paramMap) throws Exception {
		return repairDao.getSystemRepairExcelList(paramMap);
	}
	
}
