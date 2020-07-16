package com.spring.slight.mobile.main.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;
import com.spring.slight.info.service.InfoService;
import com.spring.slight.service.MainService;

@Controller
public class MobileMainController {
	@Resource(name="MainService")
	private MainService mainService;
	
	@Resource(name="InfoService")
	private InfoService infoService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/mobile/index")
	public String mobileMain(Model model) {
		Map<String, Object> lastSummaryMap = new HashMap<String, Object>();
		try {
			ResultUtil result = new ResultUtil();
			CommandMap paramMap = new CommandMap();
			paramMap.put("current_page_no", "1");
			
			lastSummaryMap = mainService.getLastSummary();
			result = infoService.getInfoNoticeList(paramMap);
			HashMap<String, Object> resultMap =  (HashMap<String, Object>) result.getData();
			List<Map<String, Object>> list = (List<Map<String, Object>>) resultMap.get("list");
			
			model.addAttribute("resultList", list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("lastSummaryMap", lastSummaryMap);
		return "mobile/main/index";
	}
	
	@RequestMapping("/mobile/login")
	public String mobileLogin() {
		return "mobile/main/login";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/mobile/notice/noticeList")
	public String mobileNotice(Model model) {
		ResultUtil result = new ResultUtil();
		
		try {
			CommandMap paramMap = new CommandMap();
			paramMap.put("current_page_no", "1");
			
			result = infoService.getInfoNoticeList(paramMap);
			HashMap<String, Object> resultMap =  (HashMap<String, Object>) result.getData();
			List<Map<String, Object>> list = (List<Map<String, Object>>) resultMap.get("list");
			for(int i=0; i<list.size(); i++	) {
//				list.get(i).put("content", list.get(i).get("content").toString().replaceAll("<(/)?([pP]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""));
				list.get(i).put("content", list.get(i).get("content").toString().replaceAll("<(no)?br[^>]*>.*?", "").replaceAll("</(no)?br[^>]*>.*?", ""));
				list.get(i).put("content", list.get(i).get("content").toString().replaceAll("<(no)?p[^>]*>.*?", "<br>").replaceAll("</(no)?p[^>]*>.*?", ""));
				list.get(i).put("content", list.get(i).get("content").toString().replaceAll("<(no)?div[^>]*>.*?", "<br>").replaceAll("</(no)?div[^>]*>.*?", ""));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("resultList", result);
		model.addAttribute("pageNm", "공지사항");
		return "/mobile/notice/noticeList";
	}
	
	@RequestMapping("/mobile/notice/guide")
	public String mobileGuide(Model model) {
		model.addAttribute("pageNm", "사용안내");
		return "/mobile/notice/guide";
	}
}
