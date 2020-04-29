package com.spring.slight.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@RequestMapping(value="/main")
	public String getMainPage(ModelMap model, HttpServletRequest request, HttpSession session) {
		return "slight/main";
	}
	
	@RequestMapping("/login")
	public String login(ModelMap model) throws Exception {
		model.addAttribute("loginChk", false);
		return "slight/main";
	}
}
