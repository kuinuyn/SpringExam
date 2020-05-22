package com.spring.slight.trouble.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.slight.trouble.service.TroubleReportService;

@Controller
@RequestMapping("/trouble")
public class TroubleReportController {
	
	@Resource(name = "TroubleReportService")
	private TroubleReportService troubleReportService;
	
	@RequestMapping("/trblReportList")
	public String trblReportList (HttpServletRequest rquest, CommandMap map) {
		return "slight/trouble/report/trblReportList";
	}
	
	@RequestMapping("/trblCreateList")
	public String trblCreateList (HttpServletRequest rquest, CommandMap map) {
		return "slight/trouble/report/trblCreateList";
	}
	
	@RequestMapping(value="/insertTrobleReport", method = RequestMethod.POST)
	public ModelAndView insertTrobleReport(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		
		try {
			resultCnt = troubleReportService.insertTrobleReport(paramMap);
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
