package com.spring.security.web;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.security.vo.CustomVO;

@Controller
public class CustomController {
	@RequestMapping(value = "/login/loginSuccess")
	public String loginSuccess(Model model, HttpSession session, HttpServletRequest request) {

		// customUserDetail에 set한 값을 getter를 통해 가져오는 작업을 가능하게 함
		CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
		
		// 이런식으로 세션에 값을 넣어주면 컨트롤러에서 사용가능
		session.setAttribute("id", vo.getUserId());
		
		return "login/loginSuccess";
	}

	@RequestMapping(value = "/login/loginFail", method = RequestMethod.GET)
	public String loginFail() {
		return "login/loginFail";
	}

	@RequestMapping(value = "/login/loginPage")
	public String login(Model model, HttpServletRequest request, HttpServletResponse response) {
		String requestPage = "login/login";

		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("id");

		if (id != null) {
			try {
				response.sendRedirect("/");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		return requestPage;
	}

	@RequestMapping(value = "/login/login_duplicate")
	public String loginDuplicate(Model model, HttpServletRequest request) {

		return "login_duplicate";
	}

	@RequestMapping(value = "/logout")
	public String pageLogin(HttpServletRequest request, HttpSession session, HttpServletResponse response) {
		String id = (String) session.getAttribute("id");
	
		if(id != null) {
			try {
				response.sendRedirect("/slight/main");
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
		session.invalidate();

		return "slight/main";
	}

}
