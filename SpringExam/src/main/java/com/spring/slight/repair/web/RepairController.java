package com.spring.slight.repair.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.util.FileDownloadUtil;
import com.spring.common.util.ResultUtil;
import com.spring.slight.repair.service.RepairService;

@Controller
@RequestMapping(value="/repair")
public class RepairController {
	
	@Resource(name="RepairService")
	private RepairService repairService;
	
	@RequestMapping("/{menu}")
	public String systemRepairList (HttpServletRequest rquest, Model model, @PathVariable String menu) {
		try {
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
			
			model.addAttribute("searchYearList", searchYearList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "slight/repair/"+menu;
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
		
	@RequestMapping(value="/updateRepairDatail", method = RequestMethod.POST)
	public ModelAndView updateRepairDatail(CommandMap paramMap, @RequestPart(value="files", required = false) List<MultipartFile> files, HttpServletRequest request, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = repairService.updateRepairDetail(paramMap, files, session);
			mv.addObject("resultCnt", resultCnt);
		}
		catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
}
