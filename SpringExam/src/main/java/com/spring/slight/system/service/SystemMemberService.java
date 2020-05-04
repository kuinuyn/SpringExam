package com.spring.slight.system.service;

import java.util.List;
import java.util.Map;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface SystemMemberService {
	public List<Map<String, Object>> getSystemMemberSearchYear() throws Exception;
	public ResultUtil getSystemMemberList(CommandMap paramMap) throws Exception;
	public Map<String, Object> getSystemMemberDetail(CommandMap paramMap) throws Exception;
	public Map<String, Object> chkMemberId(CommandMap paramMap) throws Exception;
	public int updateSystemMember(CommandMap paramMap) throws Exception;
	public int deleteSystemMember(CommandMap paramMap) throws Exception;
}
