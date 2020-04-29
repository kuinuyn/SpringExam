package com.spring.common.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.common.CommandMap;

@Controller
@RequestMapping("/common/popup")
public class PopupController {
	
	@RequestMapping(value="/popupMapTemplate")
	public String popupMapTemplate (HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		
		return "common/popup/popupMapTemplate";
	}
	
	@RequestMapping(value="/popupMapSearchTemplate")
	public String popupMapSearchTemplate (HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		
		return "common/popup/popupMapSearchTemplate";
	}
	
}
