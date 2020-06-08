package com.spring.slight.system.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;
import com.spring.slight.system.service.SystemMemberService;

@Controller
@RequestMapping("/system")
public class SystemMemberController {
	
	@Resource(name = "SystemMemberService")
	private SystemMemberService systemMemberService;
	
	@RequestMapping("/systemMemberList")
	public String systemMemberList (HttpServletRequest rquest, Model model) {
		List<String> searchYearList = new ArrayList<String>();
		Calendar cal = Calendar.getInstance();
		String year = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		year = sdf.format(cal.getTime());
		searchYearList.add(year);
		
		for(int i=0; i<9; i++) {
			cal.add(Calendar.YEAR, -1);
			year = sdf.format(cal.getTime());
			searchYearList.add(year);
		}
		
		model.addAttribute("searchYearList", searchYearList);
		
		return "slight/system/systemMemberList";
	}
	
	@RequestMapping("/getSystemMemberList")
	@ResponseBody
	public ResultUtil getSystemMemberList (HttpServletRequest rquest, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
		try {
			result = systemMemberService.getSystemMemberList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping("/getSystemMemberDetail")
	public ModelAndView getSystemMemberDetail(HttpServletRequest rquest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = systemMemberService.getSystemMemberDetail(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/chkMemberId")
	public ModelAndView chkMemberId(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			resultMap = systemMemberService.chkMemberId(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultMap", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/updateSystemMember", method = RequestMethod.POST)
	public ModelAndView updateSystemMember(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		
		try {
			resultCnt = systemMemberService.updateSystemMember(paramMap);
			mv.addObject("resultCnt", resultCnt);
		}
		catch (Exception e) {
			e.printStackTrace();
			mv.addObject("resultCnt", -1);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping(value="/deleteSystemMember", method = RequestMethod.POST)
	public ModelAndView deleteSystemMember(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		
		try {
			resultCnt = systemMemberService.deleteSystemMember(paramMap);
			mv.addObject("resultCnt", resultCnt);
		}
		catch (Exception e) {
			e.printStackTrace();
			mv.addObject("resultCnt", -1);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
}
