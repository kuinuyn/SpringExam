package com.spring.slight.mobile.main.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.slight.service.MainService;

@Controller
public class MobileMainController {
	@Resource(name="MainService")
	private MainService mainService;
	
	@RequestMapping("/mobile/index")
	public String mobileMain(Model model) {
		Map<String, Object> lastSummaryMap = new HashMap<String, Object>();
		try {
			lastSummaryMap = mainService.getLastSummary();
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
	
	@RequestMapping("/mobile/notice/noticeList")
	public String mobileNotice(Model model) {
		model.addAttribute("pageNm", "공지사항");
		return "/mobile/notice/noticeList";
	}
	
	@RequestMapping("/mobile/notice/guide")
	public String mobileGuide(Model model) {
		model.addAttribute("pageNm", "사용안내");
		return "/mobile/notice/guide";
	}
}
