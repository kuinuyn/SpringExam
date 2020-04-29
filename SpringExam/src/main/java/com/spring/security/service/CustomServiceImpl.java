package com.spring.security.service;

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
	public boolean loginChk(CustomVO vo) throws Exception {
		
		boolean loginChk = false;
		if(adminId.equals(vo.getUserId())) {
			if(password.equals(vo.getUserPw())) {
				loginChk = true;
			}
		}
		
		customDao.getCustomerCnt(vo);
		
		return loginChk;
	}
	
}
