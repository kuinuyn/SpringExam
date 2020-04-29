package com.spring.slight.repair.service;

import java.util.List;
import java.util.Map;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface RepairService {
	public ResultUtil getSystemRepairList(CommandMap paramMap) throws Exception;
	public Map<String, Object> getSystemRepairDetail(CommandMap paramMap) throws Exception;
	public List<Map<String, Object>> getSystemRepairExcelList(CommandMap paramMap) throws Exception;
}
