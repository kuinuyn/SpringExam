package com.spring.slight.service;

import java.util.Map;

import com.spring.common.CommandMap;

public interface MainService {
	public Map<String, Object> getSummary(CommandMap paramMap) throws Exception;
	public Map<String, Object> getLastSummary() throws Exception;
	public int getLightCnt(CommandMap paramMap) throws Exception;
}
