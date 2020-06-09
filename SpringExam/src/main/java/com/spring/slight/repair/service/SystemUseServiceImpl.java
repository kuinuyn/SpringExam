package com.spring.slight.repair.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.dao.SystemUseDao;

@Service("SystemUseService")
public class SystemUseServiceImpl implements SystemUseService{
	@Autowired
	private SystemUseDao systemUseDao;
	
	@Override
	public List<Map<String, Object>> getSystemUseSearchYear() throws Exception {
		return systemUseDao.getSystemUseSearchYear();
	}

	@Override
	public List<Map<String, Object>> getSystemUseSearchCom() throws Exception {
		return systemUseDao.getSystemUseSearchCom();
	}

	@Override
	public List<Map<String, Object>> getSystemUseSearchPart() throws Exception {
		return systemUseDao.getSystemUseSearchPart();
	}
	
	@Override
	public ResultUtil getSystemUseList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = systemUseDao.getSystemUseCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = systemUseDao.getSystemUseList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}
	
	@Override
	public ResultUtil getSystemUseView(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = systemUseDao.getSystemUseCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = systemUseDao.getSystemUseView(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}	

	@Override
	public Map<String, Object> getSystemUseDetail(CommandMap paramMap) throws Exception {
		return systemUseDao.getSystemUseDetail(paramMap);
	}

	@Override
	public Map<String, Object> getSystemUseDetail1(CommandMap paramMap) throws Exception {
		return systemUseDao.getSystemUseDetail1(paramMap);
	}	
	
	@Override
	public int updateSystemUse(CommandMap paramMap) throws Exception {
		int cnt = 0;
		String saveFlag = (String) paramMap.get("saveFlag");

		
		if("I".equals(saveFlag)) {
			cnt = systemUseDao.insertSystemUse(paramMap);
		}
		else if("U".equals(saveFlag)) {
			cnt = systemUseDao.updateSystemUse(paramMap);
		}
		
		return cnt;
	}

	@Override
	public int deleteSystemUse(CommandMap paramMap) throws Exception {
		return systemUseDao.deleteSystemUse(paramMap);
	}
	
}
