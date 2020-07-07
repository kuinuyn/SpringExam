package com.spring.slight.mobile.complain.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.common.CommandMap;
import com.spring.slight.complaint.service.ComplaintService;

@Controller
@RequestMapping("/mobile")
public class ComplainController {
	@Resource(name="ComplaintService")
	private ComplaintService complaintService;
	
	@RequestMapping("/complain/complainList")
	public String complainList(Model model) {
		List<String> searchYearList = getSearYear();
		
		model.addAttribute("searchYearList", searchYearList);
		model.addAttribute("pageNm", "진행결과");
		return "mobile/complain/complainList";
	}
	
	@RequestMapping("/complain/complainModify")
	public String complainModify(HttpServletRequest request, CommandMap paramMap, Model model) {
		String resultPage = "mobile/complain/complainModify";
		Authentication roleList = SecurityContextHolder.getContext().getAuthentication();
		Iterator<? extends GrantedAuthority> itr = roleList.getAuthorities().iterator();
		String resultMsg = "";
		String resultCd = "N";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<String> searchYearList = new ArrayList<String>();
		
		try {
			while(itr.hasNext()) {
				if(!itr.next().getAuthority().equals("ROLE_ADMIN")) {
					resultCd = (String) complaintService.getComplaintRoleChk(paramMap);
					
					if(!"Y".equals(resultCd)) {
						resultPage = "mobile/complain/complainList";
						searchYearList = getSearYear();
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
			resultPage = "mobile/complain/complainList";
			resultCd = "N";
			searchYearList = getSearYear();
			resultMsg = "관리자에게 문의하세요.";
			e.printStackTrace();
		}
		
		model.addAttribute("pageNm", "진행결과");
		model.addAttribute("resultCd", resultCd);
		model.addAttribute("searchYearList", searchYearList);
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultMap", resultMap);
		
		return resultPage;
	}
	
	private List<String> getSearYear() {
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
		
		return searchYearList;
	}
}
