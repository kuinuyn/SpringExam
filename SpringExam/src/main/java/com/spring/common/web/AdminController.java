package com.spring.common.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/common/admin")
public class AdminController {
	
	@RequestMapping("/commonCode")
	public String commonCode(HttpServletRequest request, HttpServletResponse response) {
		return "common/admin/commonCode";
	}
	
}
