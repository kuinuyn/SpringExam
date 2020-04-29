package com.spring.common.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.dao.CommonTagDao;

@Service("CommonTagService")
public class CommonTagServiceImpl implements CommonTagService {
	@Autowired
	private CommonTagDao commonTagDao;
	
	@Override
	public List<Map<String, Object>> getCodeList() throws Exception {
		List<Map<String, Object>> codeList = commonTagDao.getCodeList();
		
		return codeList;
	}
	
}
