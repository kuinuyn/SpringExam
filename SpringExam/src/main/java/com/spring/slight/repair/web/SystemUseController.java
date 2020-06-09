package com.spring.slight.repair.web;

import java.util.HashMap;
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
import com.spring.slight.repair.service.SystemUseService;

@Controller
@RequestMapping("/repair")
public class SystemUseController {

	@Resource(name = "SystemUseService")
	private SystemUseService systemUseService;

	@RequestMapping("/systemUseList")
	public String systemUseList (HttpServletRequest rquest, Model model) {
		try {
			model.addAttribute("searchYearList", systemUseService.getSystemUseSearchYear());
			model.addAttribute("searchComList", systemUseService.getSystemUseSearchCom());			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "slight/repair/systemUseList";
	}

	@RequestMapping("/getSystemUseList")
	@ResponseBody
	public ResultUtil getSystemUseList (HttpServletRequest rquest, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();

		try {
			result = systemUseService.getSystemUseList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@RequestMapping("/systemUseView")
	public String systemUseView (HttpServletRequest rquest, Model model) {
		try {
			model.addAttribute("searchYearList", systemUseService.getSystemUseSearchYear());
			model.addAttribute("searchComList", systemUseService.getSystemUseSearchCom());				
			model.addAttribute("searchPartList", systemUseService.getSystemUseSearchPart());			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "slight/repair/systemUseView";
	}	

	@RequestMapping("/getSystemUseView")
	@ResponseBody
	public ResultUtil getSystemUseView (HttpServletRequest rquest, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();

		try {		
			result = systemUseService.getSystemUseView(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@RequestMapping("/getSystemUseDetail")
	public ModelAndView getSystemUseDetail(HttpServletRequest rquest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();

		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = systemUseService.getSystemUseDetail(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");

		return mv;
	}

	@RequestMapping("/getSystemUseDetail1")
	public ModelAndView getSystemUseDetail1(HttpServletRequest rquest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();

		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = systemUseService.getSystemUseDetail1(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");

		return mv;
	}		

	@RequestMapping(value="/updateSystemUse", method = RequestMethod.POST)
	public ModelAndView updateSystemUse(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;

		try {
			resultCnt = systemUseService.updateSystemUse(paramMap);
			mv.addObject("resultCnt", resultCnt);
		}
		catch (Exception e) {
			e.printStackTrace();
			mv.addObject("resultCnt", -1);
		}

		mv.setViewName("jsonView");
		return mv;
	}

	@RequestMapping(value="/deleteSystemUse", method = RequestMethod.POST)
	public ModelAndView deleteSystemUse(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;

		try {
			resultCnt = systemUseService.deleteSystemUse(paramMap);
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