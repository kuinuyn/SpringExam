package com.spring.slight.mobile.main.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MobileMainController {
	@RequestMapping("/index")
	public String mobileMain() {
		return "mobile/main/index";
	}
}
