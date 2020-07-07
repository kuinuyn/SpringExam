package com.spring.slight.mobile.main.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MobileMainController {
	@RequestMapping("/mobile/index")
	public String mobileMain() {
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
