package com.spring.slight.repair.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.FileDownloadUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.service.RepairService;

@Controller
@RequestMapping(value="/repair")
public class RepairController {
	
	private static final Logger logger = LoggerFactory.getLogger(RepairController.class);
	
	@Resource(name="RepairService")
	private RepairService repairService;
	
	@RequestMapping("/systemRepairList")
	public String systemRepairList (HttpServletRequest rquest, Model model) {
		try {
			model.addAttribute("searchComInfo", repairService.getSystemRepairSearchCom());
			model.addAttribute("searchYearList", repairService.getSystemRepairSearchYear());			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "slight/repair/systemRepairList";
	}	
/*	
	@RequestMapping(value="/systemRepairList")
	public String systemRepairList(ModelMap map, HttpServletRequest request, HttpSession session) {
		
		return "slight/repair/systemRepairList";
	}
*/	
	@RequestMapping(value="/getSystemRepairList")
	@ResponseBody
	public ResultUtil getSystemRepairList(HttpServletRequest reuqest, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
		try {
			result = repairService.getSystemRepairList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@RequestMapping(value="/getSystemRepairDetail")
	public ModelAndView getSystemRepairDetail(HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = repairService.getSystemRepairDetail(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/** �뿊�� �떎�슫濡쒕뱶 **/
	@RequestMapping(value="/downloadExcel")
	public String downloadExcelFile(Model model, HttpServletRequest request, CommandMap paramMap) {
		String[] headerNm = request.getParameter("excelHeader").split(",");
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		try {
			List<Map<String, Object>> excelList = repairService.getSystemRepairExcelList(paramMap);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(excelList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "RepairAll");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
	
	@RequestMapping(value="/updateRepair", method = RequestMethod.POST)
	public ModelAndView updateRepair(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = repairService.updateRepair(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	
	@RequestMapping(value="/updateRepairCancel", method = RequestMethod.POST)
	public ModelAndView updateRepairCancel(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = repairService.updateRepairCancel(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
		
}
