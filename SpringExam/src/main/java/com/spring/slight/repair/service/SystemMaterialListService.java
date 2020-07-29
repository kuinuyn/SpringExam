package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface SystemMaterialListService {
	public List<Map<String, Object>> getMaterialSearchYear() throws Exception;
	
	public ResultUtil getSystemMaterialList(CommandMap paramMap) throws Exception;	
	public HashMap<String, Object> getSystemMaterialDetail(CommandMap paramMap) throws Exception;
	
	public int updateSystemMaterial(CommandMap paramMap) throws Exception;

	

}
