package com.spring.slight.info.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/info")
@Controller
public class InfoController {
	@RequestMapping("/{menu}")
	public String getInfo(HttpServletRequest request, @PathVariable String menu) {
		return "slight/info/"+menu;
	}
}
