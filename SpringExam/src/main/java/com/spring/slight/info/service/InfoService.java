package com.spring.slight.info.service;

import java.util.HashMap;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface InfoService {
	public ResultUtil getInfoNoticeList(CommandMap paramMap) throws Exception;	
	public HashMap<String, Object> getInfoNoticeDetail(CommandMap paramMap) throws Exception;
	
	public int updateInfoNotice(CommandMap paramMap) throws Exception;
	public int deleteInfoNotice(CommandMap paramMap) throws Exception;
}
