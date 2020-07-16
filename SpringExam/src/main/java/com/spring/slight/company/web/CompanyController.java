package com.spring.slight.company.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.security.vo.CustomVO;
import com.spring.slight.company.service.CompanyService;
import com.spring.common.CommandMap;
import com.spring.common.util.FileDownloadUtil;
import com.spring.common.util.ResultUtil;

@Controller
@RequestMapping(value = "/company")
public class CompanyController {

	@Resource(name="CompanyService")
	private CompanyService companyService;

	
	/** 보수내역입력 페이지 이동 */
	@RequestMapping( value = "/companyRepair")
	public String companyRepair(HttpServletRequest request, HttpServletResponse response, Model model) {
	
		return "slight/company/companyRepair";
	}
	
	/** 보수내역수정 페이지 이동 */
	@RequestMapping( value = "/companyRepairMod")
	public String companyRepairMod(HttpServletRequest request, HttpServletResponse response, Model model) {
	
		return "slight/company/companyRepairMod";
	}
	
	
	//보수내역입력 조회
	@RequestMapping(value="/getCompanyRepairList")
	@ResponseBody
	public ResultUtil getCompanyRepairList(HttpServletRequest request, CommandMap paramMap) {
		ResultUtil result = new ResultUtil();
		
		try {
			CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
			paramMap.put("member_id", vo.getUserId());
			
			result = companyService.getCompanyRepairList(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//상세내역조회
	@RequestMapping(value="/getCompanyRepairDetail")
	public ModelAndView getCompanyRepairDetail(HttpServletRequest reuqest, CommandMap paramMap) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = companyService.getCompanyRepairDetail(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("resultData", resultMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	//상세내역조회
		@RequestMapping(value="/getCompanyRepairMod")
		public ModelAndView getCompanyRepairMod(HttpServletRequest reuqest, CommandMap paramMap) {
			ModelAndView mv = new ModelAndView();
			Map<String, Object> resultMap = new HashMap<String, Object>();
			try {
				resultMap = companyService.getCompanyRepairDetail(paramMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			mv.addObject("resultData", resultMap);
			mv.setViewName("jsonView");
			
			return mv;
		}
	
	
	@RequestMapping(value="/updateCompanyRepair", method = RequestMethod.POST)
	public ModelAndView updateCompanyRepair(CommandMap paramMap, @RequestPart(value="files", required = false) List<MultipartFile> files, HttpServletRequest request, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		int resultCnt = 0;
		try {
			
			CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
			paramMap.put("company_id", vo.getUserId());
			resultCnt = companyService.updateCompanyRepair(paramMap, files, session);
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
		
		CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
		paramMap.put("member_id", vo.getUserId());
		
		try {
			List<Map<String, Object>> excelList = companyService.getCompanyRepairExcelList(paramMap);
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(excelList, headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "보수내역관리");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
			
	
	
	/** 게시판 - 상세 페이지 이동 */
	@RequestMapping( value = "/companyInfo")
	public String companyInfo(HttpServletRequest request, HttpServletResponse response, Model model) {
		
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
			CustomVO vo = (CustomVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
			paramMap.put("member_id", vo.getUserId());
			
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
