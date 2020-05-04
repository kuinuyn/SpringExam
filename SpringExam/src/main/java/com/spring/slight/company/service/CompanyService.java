package com.spring.slight.company.service;

import java.util.List;
import java.util.Map;

import com.spring.common.CommandMap;

public interface CompanyService {
	public List<Map<String, Object>> getCompanyInfoSearchYear() throws Exception;
	public Map<String, Object> getCompanyInfo(CommandMap commandMap) throws Exception;
	public int updateCompanyInfo(CommandMap paramMap) throws Exception;
}
