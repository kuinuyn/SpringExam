package com.spring.slight.system.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.system.dao.SystemMemberDao;

@Service("SystemMemberService")
public class SystemMemberServiceImpl implements SystemMemberService{
	@Autowired
	private SystemMemberDao systemMemberDao;
	
	@Override
	public List<Map<String, Object>> getSystemMemberSearchYear() throws Exception {
		return systemMemberDao.getSystemMemberSearchYear();
	}

	@Override
	public ResultUtil getSystemMemberList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = systemMemberDao.getSystemMemberCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = systemMemberDao.getSystemMemberList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}

	@Override
	public Map<String, Object> getSystemMemberDetail(CommandMap paramMap) throws Exception {
		return systemMemberDao.getSystemMemberDetail(paramMap);
	}

	@Override
	public Map<String, Object> chkMemberId(CommandMap paramMap) throws Exception {
		int cnt = systemMemberDao.chkMemberId(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String chkFlag = "N";
		if(cnt < 1) {
			chkFlag = "Y";
		}
		
		resultMap.put("chkFlag", chkFlag);
		return resultMap;
	}

	@Override
	public int updateSystemMember(CommandMap paramMap) throws Exception {
		int cnt = 0;
		String saveFlag = (String) paramMap.get("saveFlag");
		
		if(!paramMap.get("password").equals(paramMap.get("passwordChk"))) {
			return -2;
		}
		
		if("I".equals(saveFlag)) {
			String chkIdFlag = "";
			if(chkMemberId(paramMap) != null) {
				chkIdFlag = (String) chkMemberId(paramMap).get("chkFlag");
			}
			else {
				chkIdFlag = "N";
			}
			
			if("N".equals(chkIdFlag)) {
				return -1;
			}
			
			cnt = systemMemberDao.insertSystemMember(paramMap);
		}
		else if("U".equals(saveFlag)) {
			cnt = systemMemberDao.updateSystemMember(paramMap);
		}
		
		return cnt;
	}

	@Override
	public int deleteSystemMember(CommandMap paramMap) throws Exception {
		return systemMemberDao.deleteSystemMember(paramMap);
	}
	
}
