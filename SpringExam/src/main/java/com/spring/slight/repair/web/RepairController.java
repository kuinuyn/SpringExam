package com.spring.slight.repair.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
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
	
	@RequestMapping(value="/systemRepairList")
	public String systemRepairList(ModelMap map, HttpServletRequest request, HttpSession session) {
		
		return "slight/repair/systemRepairList";
	}
	
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
	
	/** 엑셀 다운로드 **/
	@RequestMapping(value="/downloadExcel")
	public String downloadExcelFile(Model model, HttpServletRequest request, CommandMap paramMap) {
		String[] headerNm = request.getParameter("excelHeader").split(",");
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		try {
			List<Map<String, Object>> excelList = repairService.getSystemRepairExcelList(paramMap);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(excelList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "보수이력관리");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
}
