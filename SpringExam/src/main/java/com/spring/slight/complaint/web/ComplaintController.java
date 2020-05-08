package com.spring.slight.complaint.web;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;
import com.spring.security.vo.CustomVO;
import com.spring.slight.complaint.service.ComplaintService;

@Controller
@RequestMapping(value="/complaint")
public class ComplaintController {
	@Resource(name="ComplaintService")
	private ComplaintService complaintService;
	
	@RequestMapping(value="/complaintList")
	public String complaintList(HttpServletRequest request) {
		return "slight/complaint/complaintList";
	}
	
	@RequestMapping(value="/complaintDet")
	public String complaintDet(HttpServletRequest request, Model model) {
		String resultPage = "";
		System.out.println(((CustomVO)SecurityContextHolder.getContext().getAuthentication().getDetails()).getAuthorities());
		resultPage = "slight/complaint/complaintDet";
		
		return resultPage;
	}
	
	@RequestMapping(value="/getComplaintList")
	@ResponseBody
	public ResultUtil getComplaintList(HttpServletRequest reuqest, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
		try {
			result = complaintService.getComplaintList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@RequestMapping(value="/getComplaintDetail")
	public ModelAndView getComplaintDetail(HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = complaintService.getComplaintDetail(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
}
