package com.spring.slight.company.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.security.vo.CustomVO;
import com.spring.slight.company.service.CompanyService;
import com.spring.common.CommandMap;

@Controller
@RequestMapping(value = "/company")
public class CompanyController {

	@Resource(name="CompanyService")
	private CompanyService companyService;

	/** 게시판 - 상세 페이지 이동 */
	@RequestMapping( value = "/companyInfo")
	public String companyInfo(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		try {
			model.addAttribute("searchYearList", companyService.getCompanyInfoSearchYear());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "slight/company/companyInfo";
	}	
	
	/** 게시판 - 상세 조회  */
	@RequestMapping(value = "/getCompanyInfo")
	public ModelAndView getCompanyInfo(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
		paramMap.put("member_id", vo.getUserId());
		
		try {
			resultMap = companyService.getCompanyInfo(paramMap);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mv.addObject("resultMap", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/** 게시판 - 수정 */
	@RequestMapping( value = "/updateCompanyInfo")
	@ResponseBody
	public ModelAndView updateCompanyInfo(HttpServletRequest request, HttpServletResponse response, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		
		try {
			resultCnt = companyService.updateCompanyInfo(paramMap);
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
