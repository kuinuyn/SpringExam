package com.spring.slight.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.slight.service.MainService;


@Controller
public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	@Resource(name="MainService")
	private MainService mainService;
	
	@RequestMapping(value="/main")
	public String getMainPage(ModelMap model, HttpServletRequest request, Device device) {
		Map<String, Object> lastSummaryMap = new HashMap<String, Object>();
		String resultPage = "slight/main";
		String loginChk = request.getParameter("fail");
		String domain = request.getScheme()+"://"+request.getServerName();
		
		if(device.isNormal()) {
			try {
				lastSummaryMap = mainService.getLastSummary();
			} catch (Exception e) {
				e.printStackTrace();
			}
		
			model.addAttribute("lastSummaryMap", lastSummaryMap);
		}
		else {
			if(domain.split("\\.")[0].indexOf("m") < 0) {
				domain = request.getScheme()+"://m."+request.getServerName()+":"+request.getServerPort();
			}
			
			if(loginChk != null && !"".equals(loginChk)) {
				resultPage = "redirect:"+domain+"/mobile/login?fail=true";
			}
			else {
				resultPage = "redirect:"+domain+"/index";
			}
		}
		
		logger.debug(resultPage);
		
		return resultPage;
	}
	
	@RequestMapping("/login")
	public String login(ModelMap model) throws Exception {
		Map<String, Object> lastSummaryMap = new HashMap<String, Object>();
		try {
			lastSummaryMap = mainService.getLastSummary();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("lastSummaryMap", lastSummaryMap);
		model.addAttribute("loginChk", false);
		return "slight/main";
	}
	
	@RequestMapping("/getSummary")
	public ModelAndView getSummary(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> summaryMap = new HashMap<String, Object>();
		int lightCnt = 0;
		try {
			summaryMap = mainService.getSummary(paramMap);
			lightCnt = mainService.getLightCnt(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("lightCnt", lightCnt);
		mv.addObject("summaryMap", summaryMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
}
