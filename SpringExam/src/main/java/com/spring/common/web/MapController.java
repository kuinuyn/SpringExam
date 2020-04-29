package com.spring.common.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.CommandMap;
import com.spring.common.service.MapService;
import com.spring.common.util.CommonUtil;

@Controller
@RequestMapping("/common/map")
public class MapController {
	
	@Resource(name="MapService")
	private MapService mapService;
	
	@RequestMapping(value="/mapContentDaum")
	public String mapContentDaum (HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		
		return "common/map/mapContentDaum";
	}
	
	@RequestMapping(value="/mapContentDaum2")
	public String mapContentDaum2 (HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		return "common/map/mapContentDaum2";
	}
	
	@RequestMapping(value="/mapLeftContent")
	public String mapLeftContent (HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		return "common/map/mapLeftContent";
	}
	
	@RequestMapping(value="/mapDataKakao")
	public ModelAndView mapDataKakao(HttpServletRequest request, CommandMap commandMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		CommonUtil cu = new CommonUtil();
		
		String level = cu.toParamStr((String) commandMap.get("level"), "1");
		String area = cu.toParamStr((String) commandMap.get("area"), "");
		String area2 = cu.toParamStr((String) commandMap.get("area2"), "00");
		String keytype = cu.toParamStr((String) commandMap.get("keytype"), "3");
		String keyword = cu.toParamStr((String) commandMap.get("keyword"), "");
		String dgubun = cu.toParamStr((String) commandMap.get("dgubun"), "1");
		String dongNm = cu.toParamStr((String) commandMap.get("dongNm"), "");
		String searchGubun = cu.toParamStr((String) commandMap.get("searchGubun"), "");
		String center_x = cu.toParamStr(cu.toEucKr((String) commandMap.get("center_x")), "");
		String center_y = cu.toParamStr(cu.toEucKr((String) commandMap.get("center_y")), "");
		String lightGn = cu.toParamStr((String) commandMap.get("lightGn"), "");
		
		String min_x = cu.toParamStr((String) commandMap.get("min_x"), "");
		String min_y = cu.toParamStr((String) commandMap.get("min_y"), "");
		String max_x = cu.toParamStr((String) commandMap.get("max_x"), "");
		String max_y = cu.toParamStr((String) commandMap.get("max_y"), "");
		
		double x = 0;
		double y = 0;
		
		if(!"".equals(min_x) && !"".equals(min_y) && !"".equals(max_x) && !"".equals(max_y)){
			if(Integer.parseInt(level) == 2){
				min_x = String.valueOf(Double.parseDouble(min_x) + 0.0003);
				min_y = String.valueOf(Double.parseDouble(min_y) + 0.0015);
				max_x = String.valueOf(Double.parseDouble(max_x) - 0.0006);
				max_y = String.valueOf(Double.parseDouble(max_y) - 0.0009);
			}else if(Integer.parseInt(level) > 2){
				min_x = String.valueOf(Double.parseDouble(min_x) + 0.0015);
				min_y = String.valueOf(Double.parseDouble(min_y) + 0.0045);
				max_x = String.valueOf(Double.parseDouble(max_x) - 0.0015);
				max_y = String.valueOf(Double.parseDouble(max_y) - 0.0045);
			}
		}else{
			if(!"".equals(center_x) && !"".equals(center_y)){
				x = Double.valueOf(center_x) - 0.001;
				y = Double.valueOf(center_y) - 0.002;
				if(Integer.parseInt(level) > 1){
					x = Double.valueOf(center_x) - 0.0017;
					y = Double.valueOf(center_y) - 0.0043;
				}
				min_x = String.valueOf(x);
				min_y = String.valueOf(y);
				x = Double.valueOf(center_x) + 0.001;
				y = Double.valueOf(center_y) + 0.002;
				if(Integer.parseInt(level) > 1){
					x = Double.valueOf(center_x) + 0.0017;
					y = Double.valueOf(center_y) + 0.0043;
				}
				max_x = String.valueOf(x);
				max_y = String.valueOf(y);
			}
		}
		Object returnMsg = "";
		
		try {
			returnMsg = mapService.dgetListLightMap(area, area2, keytype, keyword, min_x, max_x, min_y, max_y, (String)session.getAttribute("id"), dgubun, dongNm, searchGubun, lightGn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.addObject("returnMsg", returnMsg);
		mv.setViewName("jsonView");
		return mv;
	}
}
