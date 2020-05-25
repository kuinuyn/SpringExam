package com.spring.slight.company.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface CompanyService {
	public List<Map<String, Object>> getCompanyInfoSearchYear() throws Exception;
	public Map<String, Object> getCompanyInfo(CommandMap commandMap) throws Exception;
	public int updateCompanyInfo(CommandMap paramMap) throws Exception;
	
	public ResultUtil getCompanyRepairList(CommandMap paramMap) throws Exception;	
	public HashMap<String, Object> getCompanyRepairDetail(CommandMap paramMap) throws Exception;


	public int updateCompanyRepair(CommandMap paramMap, List<MultipartFile> files) throws Exception;
	
	public List<Map<String, Object>> getCompanyRepairExcelList(CommandMap paramMap) throws Exception;
}
