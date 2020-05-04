package com.spring.security.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.security.dao.CustomDao;
import com.spring.security.vo.CustomVO;

@Service("CustomService")
public class CustomServiceImpl implements CustomService{
	protected final static String adminId = "admin";
	protected final static String password = "admin";
	
	@Autowired
	private CustomDao customDao;
	
	@Override
	public Map<String, Object> loginChk(CustomVO vo) throws Exception {
		
		boolean loginChk = false;
		Map<String, Object> resultMap = customDao.getCustomerMap(vo);
		
		if(resultMap != null) {
			String resultPw = (String) resultMap.get("password");
			if(vo.getUserPw().equals(resultPw)) {
				loginChk = true;
			}
			
			resultMap.put("loginChk", loginChk);
		}
		
		return resultMap;
	}
	
}
