package com.spring.slight.repair.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface RepairService {
	public List<Map<String, Object>> getSystemRepairSearchCom() throws Exception;
	public List<Map<String, Object>> getSystemRepairSearchCom1() throws Exception;	
	public List<Map<String, Object>> getSystemRepairSearchYear() throws Exception;	
	public ResultUtil getSystemRepairList(CommandMap paramMap) throws Exception;
	public Map<String, Object> getSystemRepairDetail(CommandMap paramMap) throws Exception;
	public List<Map<String, Object>> getSystemRepairExcelList(CommandMap paramMap) throws Exception;
	public int updateRepair(CommandMap paramMap) throws Exception;
	public int updateRepairCancel(CommandMap paramMap) throws Exception;
}
