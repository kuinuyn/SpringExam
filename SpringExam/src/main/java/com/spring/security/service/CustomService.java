package com.spring.security.service;

import java.util.Map;

import com.spring.security.vo.CustomVO;

public interface CustomService {
	public Map<String, Object> loginChk(CustomVO vo) throws Exception;
}
