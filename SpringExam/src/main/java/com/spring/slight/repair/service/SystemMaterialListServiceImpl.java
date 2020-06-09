package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.dao.SystemMaterialListDao;

@Service("SystemMaterialListService")
public class SystemMaterialListServiceImpl implements SystemMaterialListService{
	
	@Autowired
	private SystemMaterialListDao systemMaterialList;
	
	@Override
	public List<Map<String, Object>> getMaterialSearchYear() throws Exception {
		return systemMaterialList.getMaterialSearchYear();
	}
	

	@Override
	public ResultUtil getSystemMaterialList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = systemMaterialList.getSystemMaterialCnt(paramMap);
		
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = systemMaterialList.getSystemMaterialList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}
	

	@Override
	public HashMap<String, Object> getSystemMaterialDetail(CommandMap paramMap) throws Exception {
		
		HashMap<String, Object> resultData = systemMaterialList.getSystemMaterialDetail(paramMap);
		
		return resultData;
	}

	@Override
	public int updateSystemMaterial(CommandMap paramMap) throws Exception {
		int cnt = 0;
		String saveFlag = (String) paramMap.get("flag");		
			
			if("I".equals(saveFlag)) {
				cnt = systemMaterialList.insertSystemMaterial(paramMap);
			} else if("U".equals(saveFlag)){
				cnt = systemMaterialList.updateSystemMaterial(paramMap);
			} else if ("D".equals(saveFlag)){
				cnt = systemMaterialList.deleteSystemMaterial(paramMap);
			}
			
		return cnt;
	}

	
}
