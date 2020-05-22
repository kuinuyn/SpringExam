package com.spring.slight.equipment.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
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
import com.spring.slight.company.service.CompanyService;
import com.spring.slight.equipment.service.EquipmentService;

@Controller
@RequestMapping("/equipment")
public class EquipmentController {
	
	@Resource(name="EquipmentService")
	private EquipmentService equipmentSerivce;
	
	@Resource(name="CompanyService")
	private CompanyService companyService;
	
	/**
	 * 
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * 
	 * 보안등기본정보관리 호출
	 */
	@RequestMapping(value="/{menu}")
	public String equipment(HttpServletRequest request, CommandMap paramMap, @PathVariable String menu, Model model) {
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
	
	@RequestMapping(value="/getEquipStaitsticeList")
	public ModelAndView getEquipStaitstice(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		List<LinkedHashMap<String, Object>> result = new ArrayList<LinkedHashMap<String, Object>>();
		
		try {
			result = equipmentSerivce.getEquipStaitstice(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping(value="/getCompanyId")
	public ModelAndView getCompanyId(HttpServletRequest request, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		
		try {
			result = equipmentSerivce.getCompanyId(paramMap);
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
	
	@RequestMapping(value="/saveGisEquipment", method = RequestMethod.POST)
	public ModelAndView saveGisEquipment(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = equipmentSerivce.saveGisEquipment(paramMap);
			mv.addObject("resultCnt", resultCnt);
		} catch (Exception e) {
			mv.addObject("resultCnt", -1);
			e.printStackTrace();
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping(value="/deleteEquipment", method = RequestMethod.POST)
	public ModelAndView deleteEquipment(CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			resultCnt = equipmentSerivce.deleteEquipment(paramMap);
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
	
	@RequestMapping(value="/excelSummaryDownload")
	public String excelSummaryDownload(Model model, HttpServletRequest request, CommandMap paramMap) {
		String[] headerNm = request.getParameter("excelHeader").split(",");
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		try {
			List<LinkedHashMap<String, Object>> excelList = equipmentSerivce.getEquipStaitstice(paramMap);
			List<?> resultList = excelHeaderMapping(excelList, headerNm);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(resultList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "통계현황");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
	
	@RequestMapping(value="/excelListDownLoad")
	public String excelListDownLoad(Model model, HttpServletRequest request, CommandMap paramMap) {
		String[] headerNm = headerNmMapping(paramMap);
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		
		try {
			List<Map<String, Object>> excelList = equipmentSerivce.excelListDownLoad(paramMap);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(excelList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "통계현황");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
	
	private String[] headerNmMapping(CommandMap paramMap) {
		String[] headerNm = null;
		String excelGubun = (String) paramMap.get("excelGubun");
		
		if("LIGHT".equals(excelGubun)) {
			headerNm = new String[] {"순번", "등종류", "관리번호", "행정동", "주소", "새주소", "지지방식", "광원종류", "광원용량", "등상태", "한전고객번호", "인입주", "X좌표", "Y좌표", "등기구형태", "점멸기", "설치년도", "변대주"};
		}
		else if("REPAIR".equals(excelGubun)) {
			headerNm = new String[] {"순번", "접수번호", "관리번호", "행정동", "등구분", "처리현황", "작업비고", "최종등록일"};
		}
		else if("USE".equals(excelGubun)) {
			headerNm = new String[] {"순번", "연번", "날짜", "품명", "규격", "입고", "출고", "잔고", "시공업체", "접수번호", "비고"};
		}
		else {
			headerNm = new String[] {"순번", "날짜", "품명", "규격", "단위", "입고", "출고", "잔고", "시공업체", "비고"};
		}
		
		return headerNm;
	}
	
	private List<?> excelHeaderMapping(List<LinkedHashMap<String, Object>> excelList, String[] headerNm) {
		List<LinkedHashMap<String, Object>> resultList = new ArrayList<LinkedHashMap<String,Object>>();
		LinkedHashMap<String, Object> resultMap = new LinkedHashMap<String, Object>();
		Iterator<String> itr = null;
		String value = "";
		String key = "";
		int idx= 0;
		
		for(LinkedHashMap<String, Object> map : excelList)	 {
			itr = map.keySet().iterator();
			idx= 0;
			resultMap = new LinkedHashMap<String, Object>();
			
			while(itr.hasNext()) {
				key = itr.next();
				value = String.valueOf(map.get(key));
				resultMap.put(headerNm[idx++], value);
			}
			
			resultList.add(resultMap);
		}
		
		
		return resultList;
	}
}
