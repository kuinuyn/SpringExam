package com.spring.slight.complaint.service;

import java.util.Map;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface ComplaintService {
	public ResultUtil getComplaintList(CommandMap paramMap) throws Exception;
	public Map<String, Object> getComplaintDetail(CommandMap paramMap) throws Exception;
}
