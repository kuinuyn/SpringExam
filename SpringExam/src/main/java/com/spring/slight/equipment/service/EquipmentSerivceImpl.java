package com.spring.slight.equipment.service;

import java.util.HashMap;
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
	
	@Override
	public ResultUtil getEquipmentList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = equipmentDao.getEquipmentCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = equipmentDao.getEquipmentList(paramMap);
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
	public List<Map<String, Object>> getEquipmentExcelList(CommandMap paramMap) throws Exception {
		return equipmentDao.getDetRepirList(paramMap);
	}
	
}
