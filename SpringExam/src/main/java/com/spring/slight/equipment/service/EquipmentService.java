package com.spring.slight.equipment.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.util.ResultUtil;

public interface EquipmentService {
	public ResultUtil getEquipmentList(CommandMap paramMap) throws Exception;
	public HashMap<String, Object> getEquipmentDet(CommandMap paramMap) throws Exception;
	public List<LinkedHashMap<String, Object>> getEquipStaitstice(CommandMap paramMap) throws Exception;
	public int updateEquipment(CommandMap paramMap, List<MultipartFile> files) throws Exception;
	public int saveGisEquipment(CommandMap paramMap) throws Exception;
	public int deleteEquipment(CommandMap paramMap) throws Exception;
	public List<Map<String, Object>> getEquipmentExcelList(CommandMap paramMap) throws Exception;
	public List<Map<String, Object>> getCompanyId(CommandMap paramMap) throws Exception;
	public List<Map<String, Object>> excelListDownLoad(CommandMap paramMap) throws Exception;
}
