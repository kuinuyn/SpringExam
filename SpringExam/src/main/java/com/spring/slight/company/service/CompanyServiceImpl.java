package com.spring.slight.company.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.slight.company.dao.CompanyDao;

@Service("CompanyService")
public class CompanyServiceImpl implements CompanyService{
	
	@Autowired
	private CompanyDao companyDao;
	
	@Override
	public List<Map<String, Object>> getCompanyInfoSearchYear() throws Exception {
		return companyDao.getCompanyInfoSearchYear();
	}

	@Override
	public Map<String, Object> getCompanyInfo(CommandMap commandMap) throws Exception {
		return companyDao.getCompanyInfo(commandMap);
	}

	@Override
	public int updateCompanyInfo(CommandMap paramMap) throws Exception {
		return companyDao.updateCompanyInfo(paramMap);
	}
}
