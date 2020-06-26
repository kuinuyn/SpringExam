package com.spring.common.service;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.dao.MapDao;

@Service("MapService")
public class MapServiceImpl implements MapService {

	@Autowired
	private MapDao mapDao;
	
	@Override
	public Object dgetListLightMap(String area, String area2, String keytype, String keyword,
			String minX, String maxX, String minY, String maxY, String CheckLogin, String dgubun, String dongNm,
			String searchGubun, String lightGn) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("area", area);paramMap.put("area2", area2);paramMap.put("keytype", keytype);paramMap.put("keyword", URLDecoder.decode(keyword,"UTF-8"));
		paramMap.put("minX", minX);paramMap.put("maxX", maxX);paramMap.put("minY", minY);
		paramMap.put("maxY", maxY);paramMap.put("CheckLogin", CheckLogin);paramMap.put("dgubun", dgubun);
		paramMap.put("dongNm", dongNm);paramMap.put("searchGubun", searchGubun);paramMap.put("lightGn", lightGn);
		
		List<Map<String, Object>> list = mapDao.resultData(paramMap);
		Object returnData = returnData(list);
		
		return returnData;
	}
	
	public Object returnData(List<Map<String, Object>> list) {
		Object returnData = "";
		String rstData = "";
		if ( list != null && list.size() > 0 ) {
			for ( int i = 0; i <list.size(); i++ ) {
				if(i != 0) {
					rstData += "^"+i+"|".concat((String) list.get(i).get("light_no")).concat("|").concat((String) list.get(i).get("address")).concat("|").concat((String) list.get(i).get("map_x_pos")).concat("|")
							.concat((String) list.get(i).get("map_y_pos")).concat("|").concat((String) list.get(i).get("pole_no")).concat("|").concat((String) list.get(i).get("stand_cd")).concat("|")
							.concat((String) list.get(i).get("lamp2_cd")).concat("|").concat((String) list.get(i).get("lamp3_cd")).concat("|").concat((String) list.get(i).get("auto_jum_type1_cd")).concat("|")
							.concat((String) list.get(i).get("lamp1_cd")).concat("|").concat((String) list.get(i).get("bdj")).concat("|").concat((String) list.get(i).get("new_address")).concat("|")
							.concat((String) list.get(i).get("up_lighter")).concat("|").concat((String) list.get(i).get("light_type")).concat("|").concat((String) list.get(i).get("kepco_cust_no")).concat("|")
							.concat((String) list.get(i).get("hj_dong_cd")).concat("|").concat((String) list.get(i).get("kepco_cd")).concat("|").concat((String) list.get(i).get("use_light")).concat("|");
				}
				else {
					rstData = i+"|".concat((String) list.get(i).get("light_no")).concat("|").concat((String) list.get(i).get("address")).concat("|").concat((String) list.get(i).get("map_x_pos")).concat("|")
							.concat((String) list.get(i).get("map_y_pos")).concat("|").concat((String) list.get(i).get("pole_no")).concat("|").concat((String) list.get(i).get("stand_cd")).concat("|")
							.concat((String) list.get(i).get("lamp2_cd")).concat("|").concat((String) list.get(i).get("lamp3_cd")).concat("|").concat((String) list.get(i).get("auto_jum_type1_cd")).concat("|")
							.concat((String) list.get(i).get("lamp1_cd")).concat("|").concat((String) list.get(i).get("bdj")).concat("|").concat((String) list.get(i).get("new_address")).concat("|")
							.concat((String) list.get(i).get("up_lighter")).concat("|").concat((String) list.get(i).get("light_type")).concat("|").concat((String) list.get(i).get("kepco_cust_no")).concat("|")
							.concat((String) list.get(i).get("hj_dong_cd")).concat("|").concat((String) list.get(i).get("kepco_cd")).concat("|").concat((String) list.get(i).get("use_light")).concat("|");
				}
			}
			
			returnData = rstData;
		}
		else {
			returnData = false;
		}
		
		return returnData;
	}
	
}
