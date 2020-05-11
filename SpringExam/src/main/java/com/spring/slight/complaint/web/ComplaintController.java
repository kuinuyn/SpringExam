package com.spring.slight.complaint.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;
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
	
	@RequestMapping(value="/complaintDet")
	public String complaintDet(HttpServletRequest request, Model model, CommandMap paramMap) {
		String resultPage = "slight/complaint/complaintDet";
		Authentication roleList = SecurityContextHolder.getContext().getAuthentication();
		Iterator<? extends GrantedAuthority> itr = roleList.getAuthorities().iterator();
		String resultMsg = "";
		String resultCd = "N";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			while(itr.hasNext()) {
				if(!itr.next().getAuthority().equals("ROLE_ADMIN")) {
					resultCd = (String) complaintService.getComplaintRoleChk(paramMap);
					
					if(!"Y".equals(resultCd)) {
						resultPage = "slight/complaint/complaintList";
						resultMsg = "비밀번호를 확인하세요.";
					}
					else {
						resultMap = complaintService.getComplaintDetail(paramMap);
					}
				}
				else {
					resultMap = complaintService.getComplaintDetail(paramMap);
				}
			}
		} catch (Exception e) {
			resultPage = "slight/complaint/complaintList";
			resultCd = "N";
			resultMsg = "관리자에게 문의하세요.";
			e.printStackTrace();
		}
		
		model.addAttribute("resultCd", resultCd);
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultMap", resultMap);
		
		return resultPage;
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
	
	/** 게시판 - 수정 */
	@RequestMapping( value = "/updateComplaint")
	@ResponseBody
	public ModelAndView updateComplaint(HttpServletRequest request, HttpServletResponse response, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		
		try {
			resultCnt = complaintService.updateComplaint(paramMap);
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
