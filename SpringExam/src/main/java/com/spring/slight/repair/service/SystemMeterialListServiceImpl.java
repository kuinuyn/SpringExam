package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.dao.SystemMeterialListDao;

@Service("SystemMeterialListService")
public class SystemMeterialListServiceImpl implements SystemMeterialListService{
	
	@Autowired
	private SystemMeterialListDao systemMeterialList;
	
	@Override
	public List<Map<String, Object>> getMeterialSearchYear() throws Exception {
		return systemMeterialList.getMeterialSearchYear();
	}
	

	@Override
	public ResultUtil getSystemMeterialList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = systemMeterialList.getSystemMeterialCnt(paramMap);
		
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = systemMeterialList.getSystemMeterialList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}
	

	@Override
	public HashMap<String, Object> getSystemMeterialDetail(CommandMap paramMap) throws Exception {
		
		HashMap<String, Object> resultData = systemMeterialList.getSystemMeterialDetail(paramMap);
		
		return resultData;
	}

	@Override
	public int updateSystemMeterial(CommandMap paramMap) throws Exception {
		int cnt = 0;
		String saveFlag = (String) paramMap.get("flag");		
			
			if("I".equals(saveFlag)) {
				cnt = systemMeterialList.insertSystemMeterial(paramMap);
			} else if("U".equals(saveFlag)){
				cnt = systemMeterialList.updateSystemMeterial(paramMap);
			} else if ("D".equals(saveFlag)){
				cnt = systemMeterialList.deleteSystemMeterial(paramMap);
			}
			
		return cnt;
	}

	
}
