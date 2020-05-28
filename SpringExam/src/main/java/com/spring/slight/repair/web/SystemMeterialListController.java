package com.spring.slight.repair.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.security.vo.CustomVO;
import com.spring.slight.repair.service.SystemMeterialListService;
import com.spring.common.CommandMap;
import com.spring.common.util.FileDownloadUtil;
import com.spring.common.util.ResultUtil;

@Controller
@RequestMapping(value = "/repair")
public class SystemMeterialListController {

	@Resource(name="SystemMeterialListService")
	private SystemMeterialListService systemMeterialService;

	
	/** 보수내역입력 페이지 이동 */
	@RequestMapping( value = "/systemMeterialList")
	public String systemMeterialList(HttpServletRequest request, HttpServletResponse response, Model model) {
	
		/*
		try {
			model.addAttribute("searchYearList", systemMeterialService.getMeterialSearchYear());
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		
		
		return "slight/repair/systemMeterialList";
	}
	
	
	//보수내역입력 조회
	@RequestMapping(value="/getSystemMeterialList")
	@ResponseBody
	public ResultUtil getSystemMeterialList(HttpServletRequest request, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
				try {
			result = systemMeterialService.getSystemMeterialList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//상세내역조회
	@RequestMapping(value="/getSystemMeterialDetail")
	public ModelAndView getSystemMeterialDetail(HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			resultMap = systemMeterialService.getSystemMeterialDetail(paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/updateSystemMeterial")
	public ModelAndView updateSystemMeterial( HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		System.out.println("start");
		try {
			resultCnt = systemMeterialService.updateSystemMeterial(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}

		System.out.println("end");	
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	
	
			
	
	
	
}
