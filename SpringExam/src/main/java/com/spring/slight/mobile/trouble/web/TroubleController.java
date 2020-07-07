package com.spring.slight.mobile.trouble.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mobile")
public class TroubleController {
	@RequestMapping("/trouble/troubleReport")
	public String troubleList(Model model) {
		model.addAttribute("pageNm", "고장신고");
		return "mobile/trouble/troubleReport";
	}
	
	@RequestMapping("/trouble/troubleMap")
	public String troubleMap(Model model) {
		model.addAttribute("pageNm", "고장신고");
		return "mobile/trouble/troubleMap";
	}
}
