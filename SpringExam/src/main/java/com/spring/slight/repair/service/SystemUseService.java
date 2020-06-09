package com.spring.slight.repair.service;

import java.util.List;
import java.util.Map;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface SystemUseService {
	public List<Map<String, Object>> getSystemUseSearchYear() throws Exception;
	public List<Map<String, Object>> getSystemUseSearchCom() throws Exception;
	public List<Map<String, Object>> getSystemUseSearchPart() throws Exception;	
	public ResultUtil getSystemUseList(CommandMap paramMap) throws Exception;
	public ResultUtil getSystemUseView(CommandMap paramMap) throws Exception;	
	public Map<String, Object> getSystemUseDetail(CommandMap paramMap) throws Exception;
	public Map<String, Object> getSystemUseDetail1(CommandMap paramMap) throws Exception;	
	public int updateSystemUse(CommandMap paramMap) throws Exception;
	public int deleteSystemUse(CommandMap paramMap) throws Exception;
}
