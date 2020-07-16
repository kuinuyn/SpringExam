package com.spring.slight.info.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;
import com.spring.security.vo.CustomVO;
import com.spring.slight.info.service.InfoService;

@Controller
@RequestMapping("/info")
public class InfoController {
	
	@Resource(name="InfoService")
	private InfoService infoService;
	
	@RequestMapping(value="/{menu}")
	public String getInfo(HttpServletRequest request, @PathVariable String menu, Model model) {
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
		
		if("infoNoticeList".equals(menu)) {
			model.addAttribute("searchYearList", searchYearList);
		}
		else if("infoNoticeSave".equals(menu)) {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			String no = request.getParameter("no");
			if(no != null && !"".equals(no)) {
				try {
					CommandMap paramMap = new CommandMap();
					paramMap.put("no", no);
					resultMap = infoService.getInfoNoticeDetail(paramMap);
					model.addAttribute("resultMap", resultMap);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	
		return "slight/info/"+menu;
	}
	
	//보수내역입력 조회
	@RequestMapping(value="/getInfoNoticeList")
	@ResponseBody
	public ResultUtil getInfoNoticeList(HttpServletRequest request, CommandMap paramMap) {
		
		ResultUtil result = new ResultUtil();
		
		try {
			result = infoService.getInfoNoticeList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//상세내역조회
	@RequestMapping(value="/getInfoNoticeDetail")
	public ModelAndView getSystemMaterialDetail(HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			resultMap = infoService.getInfoNoticeDetail(paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/updateInfoNotice", method = RequestMethod.POST)
	public ModelAndView updateInfoNotice(HttpServletRequest request, HttpServletResponse response, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView("jsonView");
		int resultCnt = 0;
		try {
			CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
			paramMap.put("upd_id", vo.getUserId());
			
			resultCnt = infoService.updateInfoNotice(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}

		return mv;
	}
	
	@RequestMapping(value="/deleteInfoNotice", method = RequestMethod.POST)
	public ModelAndView deleteInfoNotice(HttpServletRequest request, HttpServletResponse response, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView("jsonView");
		int resultCnt = 0;
		try {
			resultCnt = infoService.deleteInfoNotice(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}

		return mv;
	}
}
