package com.spring.slight.info.service;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.info.dao.InfoDao;

@Service("InfoService")
public class InfoServiceImpl implements InfoService{
	
	@Autowired
	private InfoDao infoNoticeList;
	
	@Override
	public ResultUtil getInfoNoticeList(CommandMap paramMap) throws Exception {
		
		ResultUtil result = new ResultUtil();
		int totalCount = infoNoticeList.getInfoNoticeListCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = infoNoticeList.getInfoNoticeList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Collections.sort(list, new Comparator<Map<String, Object>>() {

			@Override
			public int compare(Map<String, Object> o1, Map<String, Object> o2) {
				Integer i = Integer.parseInt(o1.get("no").toString());
				Integer j = Integer.parseInt(o2.get("no").toString());
				return j.compareTo(i);
			}
			
		});
		
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		resultMap.put("current_page_no", paramMap.get("current_page_no"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}
	

	@Override
	public HashMap<String, Object> getInfoNoticeDetail(CommandMap paramMap) throws Exception {
		
		HashMap<String, Object> resultData = infoNoticeList.getInfoNoticeDetail(paramMap);
		
		return resultData;
	}

	@Override
	public int updateInfoNotice(CommandMap paramMap) throws Exception {
		int cnt = 0;
		String no = (String) paramMap.get("no");
			
			if(!"".equals(no.trim()) && no.trim() != null) {
				cnt = infoNoticeList.updateInfoNotice(paramMap);
			} else {
				cnt = infoNoticeList.insertInfoNotice(paramMap);
			} 
			
		return cnt;
	}


	@Override
	public int deleteInfoNotice(CommandMap paramMap) throws Exception {
		return infoNoticeList.deleteInfoNotice(paramMap);
	}
	
}
