package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface SystemMeterialListService {
	public List<Map<String, Object>> getMeterialSearchYear() throws Exception;
	
	public ResultUtil getSystemMeterialList(CommandMap paramMap) throws Exception;	
	public HashMap<String, Object> getSystemMeterialDetail(CommandMap paramMap) throws Exception;
	
	public int updateSystemMeterial(CommandMap paramMap) throws Exception;

	

}
