package com.spring.slight.equipment.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.spring.slight.equipment.service.EquipmentService;

@Controller
@RequestMapping("/equipment")
public class EquipmentController {
	
	@Resource(name="EquipmentService")
	private EquipmentService equipmentSerivce;
	
	/**
	 * 
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * 
	 * 보안등기본정보관리 호출
	 */
	@RequestMapping(value="/{menu}")
	public String equipment(HttpServletRequest request, CommandMap paramMap, @PathVariable String menu) {
		
		return "slight/equipment/"+menu;
	}
	
	@RequestMapping(value="/getEquipmentList")
	@ResponseBody
	public ResultUtil getEquipmentList(HttpServletRequest request, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
		try {
			result = equipmentSerivce.getEquipmentList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * 
	 * 보안등기본정보관리 디데일 정보
	 */
	@RequestMapping(value="/equipmentDet")
	public ModelAndView EquipmentDet(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		try {
			result = equipmentSerivce.getEquipmentDet(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/getEquipmentMod")
	public ModelAndView getEquipmentMod(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		try {
			result = equipmentSerivce.getEquipmentDet(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/updateEquipment", method = RequestMethod.POST)
	public ModelAndView updateEquipment(CommandMap paramMap, @RequestPart(value="files", required = false) List<MultipartFile> files) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = equipmentSerivce.updateEquipment(paramMap, files);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	/** 엑셀 다운로드 **/
	@RequestMapping(value="/downloadExcel")
	public String downloadExcelFile(Model model, HttpServletRequest request, CommandMap paramMap) {
		String[] headerNm = request.getParameter("excelHeader").split(",");
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		try {
			List<Map<String, Object>> excelList = equipmentSerivce.getEquipmentExcelList(paramMap);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(excelList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "수리내역");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
}
