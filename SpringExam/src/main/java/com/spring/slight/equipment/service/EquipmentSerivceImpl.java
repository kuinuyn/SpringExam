package com.spring.slight.equipment.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.dao.FileDao;
import com.spring.common.util.FileUploadUtil;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;
import com.spring.common.vo.FilesVO;
import com.spring.slight.equipment.dao.EquipmentDao;

@Service("EquipmentService")
public class EquipmentSerivceImpl implements EquipmentService{

	@Autowired
	private EquipmentDao equipmentDao;
	
	@Autowired
	private FileDao fileDao;
	
	private String key;
	private String seq;
	
	@Override
	public ResultUtil getEquipmentList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = equipmentDao.getEquipmentCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		if(paramMap.get("orderNm") != null && !"".equals(paramMap.get("orderNm"))) {
			this.seq = paramMap.get("order").toString();
			if("관리번호".equals(paramMap.get("orderNm"))) {
				this.key = "light_no";
			}
			
			paramMap.put("orderNm", this.key);
		}
		
		List<Map<String, Object>> list = equipmentDao.getEquipmentList(paramMap);
		
		if(this.key != null && !"".equals(this.key)) {
			Collections.sort(list, new Comparator<Map<String, Object>>() {
				@Override
				public int compare(Map<String, Object> o1, Map<String, Object> o2) {
					if("1".equals(seq)) {
						return o1.get(key).toString().compareTo(o2.get(key).toString());
					}
					else {
						return o2.get(key).toString().compareTo(o1.get(key).toString());
					}
					
				}
			});
		}
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}

	@Override
	public HashMap<String, Object> getEquipmentDet(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultData = equipmentDao.getEquipmentDet(paramMap);
		FilesVO filesVo = new FilesVO();
		filesVo.setSeq((String) paramMap.get("light_no"));
		
		List<FilesVO> filesList = fileDao.getFilesList(filesVo);
		List<Map<String, Object>> detRepirList = equipmentDao.getDetRepirList(paramMap);
		if(filesList.size() > 0) {
			resultData.put("downLoadFiles", filesList);
		}
		if(detRepirList.size() > 0) {
			resultData.put("detRepirList", detRepirList);
		}
		
		return resultData;
	}
	
	

	@Override
	public List<LinkedHashMap<String, Object>> getEquipStaitstice(CommandMap paramMap) throws Exception {
		String searchGubun = (String) paramMap.get("searchGubun");
		String tabGun = (String) paramMap.get("tabGubun");
		List<LinkedHashMap<String, Object>> resultList = new ArrayList<LinkedHashMap<String,Object>>();
		LinkedHashMap<String,  Object> hjEmpty = new LinkedHashMap<String, Object>();
		
		if("RIGHT".equals(tabGun)) {
			if(searchGubun.equals("0")) {
				resultList = equipmentDao.getEquipHJStaitstice(paramMap);
			}
			else if(searchGubun.equals("1")) {
				resultList = equipmentDao.getEquipStandStaitstice(paramMap);
			}
			else if(searchGubun.equals("2")) {
				resultList = equipmentDao.getEquipLamp2Staitstice(paramMap);
			}
			else if(searchGubun.equals("3")) {
				resultList = equipmentDao.getEquipLamp3Staitstice(paramMap);
			}
			
			hjEmpty = resultList.get(0);
			hjEmpty.put("hj_dong_nm", "기타");
			
			resultList.remove(0);
			resultList.add(hjEmpty);
			
			LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
			map.put("idx", "");
			map.put("hj_dong_nm", "합계");
			Iterator<String> itr = null;
			String key = "";
			int total = 0;
			for(int i=0; i<resultList.size(); i++) {
				resultList.get(i).put("idx", String.valueOf((i+1)));
				itr = resultList.get(i).keySet().iterator();
				
				while(itr.hasNext()) {
					key = itr.next();
					total = 0;
					
					if(!key.toUpperCase().equals("IDX") && !key.toUpperCase().equals("HJ_DONG_NM")) {
						if(i == 0) {
							total = Integer.parseInt(String.valueOf(resultList.get(i).get(key)));
						}
						else {
							
							total = Integer.parseInt(String.valueOf(resultList.get(i).get(key)))+Integer.parseInt(String.valueOf(map.get(key)));
						}
						
						map.put(key, total);
					}
				}
			}
			
			resultList.add(map);
		}
		else if("REPAIR".equals(tabGun)) {
			resultList = equipmentDao.getComplaintList(paramMap);
		}
		
		return resultList;
	}
	
	@Override
	public List<Map<String, Object>> getCompanyId(CommandMap paramMap) throws Exception {
		return equipmentDao.getCompanyId(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> excelListDownLoad(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		String excelGubun = (String) paramMap.get("excelGubun");
		int idx = 0;
		
		if("LIGHT".equals(excelGubun)) {
			resultList = equipmentDao.getLightList(paramMap);
			
			for(Map<String, Object> resultMap : resultList) {
				resultMap.put("순번", ++idx);
			}
			
		}
		else if("REPAIR".equals(excelGubun)) {
			resultList = equipmentDao.getRepairList(paramMap);
			
			for(Map<String, Object> resultMap : resultList) {
				resultMap.put("순번", ++idx);
			}
		}
		else if("USE".equals(excelGubun)) {
			resultList = equipmentDao.getMaterialUseList(paramMap);
			
			for(Map<String, Object> resultMap : resultList) {
				resultMap.put("순번", ++idx);
			}
		}
		else {
			resultList = equipmentDao.getMaterialList(paramMap);
			
			for(Map<String, Object> resultMap : resultList) {
				resultMap.put("순번", ++idx);
			}
		}
		
		return resultList;
	}

	@Override
	public int updateEquipment(CommandMap paramMap, List<MultipartFile> paramFiles) throws Exception {
		int resultCnt = equipmentDao.updateEquipment(paramMap);
		
		String deleteFile = (String) paramMap.get("delete_file");
		String[] deleteFileInfo = new String[2];
		FilesVO filesVo = new FilesVO();
		if(!"".equals(deleteFile)) {
			if(deleteFile.indexOf("|") > -1) {
				String[] deleteFilesInfo = deleteFile.split("\\|");
				for(int i=0; i < deleteFilesInfo.length; i++) {
					deleteFileInfo = deleteFilesInfo[i].split("\\!");
					filesVo.setSeq(deleteFileInfo[0]);
					filesVo.setFile_no(Integer.parseInt(deleteFileInfo[1]));
					
					fileDao.deleteFiles(filesVo);
				}
			}
			else {
				deleteFileInfo = deleteFile.split("!");
				
				filesVo.setSeq(deleteFileInfo[0]);
				filesVo.setFile_no(Integer.parseInt(deleteFileInfo[1]));
				
				fileDao.deleteFiles(filesVo);
			}
		}
		
		List<FilesVO> files = FileUploadUtil.setFileUploadUtil(paramFiles, (String) paramMap.get("light_no"), "light");
		
		for(FilesVO file : files) {
			fileDao.insertFiles(file);
		}
		
		return resultCnt;
	}
	
	@Override
	public int saveGisEquipment(CommandMap paramMap) throws Exception {
		String flag = (String) paramMap.get("flag");
		int cnt = 0;
		
		String lightNo = ((String) paramMap.get("light_no")).replaceAll("\\p{Z}", "").trim();
		paramMap.put("light_no", lightNo);
		
		if(flag.equals("I")) {
			if(equipmentDao.getChkLightNo(paramMap) < 1) {
				cnt = equipmentDao.insertGisEquipment(paramMap);
			}
			else {
				cnt = -2;
			}
		}
		else if(flag.equals("U")){
			cnt = equipmentDao.updateGisEquipment(paramMap);
		}
		
		return cnt;
	}

	@Override
	public int deleteEquipment(CommandMap paramMap) throws Exception {
		int resultCnt = equipmentDao.deleteEquipment(paramMap);
		
		FilesVO file = new FilesVO();
		file.setSeq((String) paramMap.get("light_no"));
		
		if(resultCnt > 0) {
			fileDao.deleteFile(file);
		}
		
		return resultCnt;
	}

	@Override
	public List<Map<String, Object>> getEquipmentExcelList(CommandMap paramMap) throws Exception {
		return equipmentDao.getDetRepirList(paramMap);
	}

}
