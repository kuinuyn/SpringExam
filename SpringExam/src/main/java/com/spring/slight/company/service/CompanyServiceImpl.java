package com.spring.slight.company.service;

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
import com.spring.slight.company.dao.CompanyDao;

@Service("CompanyService")
public class CompanyServiceImpl implements CompanyService{
	
	@Autowired
	private CompanyDao companyDao;
	
	@Autowired
	private FileDao fileDao;
	
	@Override
	public List<Map<String, Object>> getCompanyInfoSearchYear() throws Exception {
		return companyDao.getCompanyInfoSearchYear();
	}

	@Override
	public Map<String, Object> getCompanyInfo(CommandMap commandMap) throws Exception {
		return companyDao.getCompanyInfo(commandMap);
	}

	@Override
	public int updateCompanyInfo(CommandMap paramMap) throws Exception {
		return companyDao.updateCompanyInfo(paramMap);
	}
	
	
	
	@Override
	public ResultUtil getCompanyRepairList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = companyDao.getCompanyRepairCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = companyDao.getCompanyRepairList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		return result;
	}
	

	@Override
	public HashMap<String, Object> getCompanyRepairDetail(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultData = companyDao.getCompanyRepairDetail(paramMap);
		FilesVO filesVo = new FilesVO();
		filesVo.setSeq((String) paramMap.get("repairNo"));
		List<FilesVO> filesList = fileDao.getFilesList(filesVo);
		if(filesList.size() > 0) {
			resultData.put("downLoadFiles", filesList);
		}
		
		return resultData;
	}

	@Override
	public int updateCompanyRepair(CommandMap paramMap, List<MultipartFile> paramFiles) throws Exception {
		
		int resultCnt = companyDao.updateCompanyRepair(paramMap);
		
		String deleteFile = (String) paramMap.get("delete_file");
		
		String[] deleteFileInfo = new String[3];
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
		
		List<FilesVO> files = FileUploadUtil.setFileUploadUtil(paramFiles, (String) paramMap.get("repair_no"), "repair");
		String photo1 = (String) paramMap.get("photo1");
		String photo2 = (String) paramMap.get("photo2");
		String photo3 = (String) paramMap.get("photo3");
		
		int cnt = 0;
		for(FilesVO file : files) {
			if(cnt > -1) {
				if(!"".equals(photo1) && photo1 != null) {
					file.setFile_no(Integer.parseInt(photo1));
					photo1 = "";
				}
				else if(!"".equals(photo2) && photo2 != null) {
					file.setFile_no(Integer.parseInt(photo2));
					photo2 = "";
				}
				else if(!"".equals(photo3) && photo3 != null) {
					file.setFile_no(Integer.parseInt(photo3));
					photo3 = "";
				}
			}
			else if(cnt > 0) {
				if(!"".equals(photo2) && photo2 != null) {
					file.setFile_no(Integer.parseInt(photo2));
					photo2 = "";
				}
				else if(!"".equals(photo3) && photo3 != null) {
					file.setFile_no(Integer.parseInt(photo3));
					photo3 = "";
				}
			}
			else if(cnt > 1) {
				if(!"".equals(photo3) && photo3 != null) {
					file.setFile_no(Integer.parseInt(photo3));
					photo3 = "";
				}
			}
			
			if(fileDao.getFileNo(file) > 0) {
				fileDao.updateFiles(file);
			}
			else {
				fileDao.insertFiles(file);
			}
			
			cnt++;
		}
		
		int resultCnt2 = companyDao.updateCompanyRepairPart(paramMap);
		return resultCnt;
	}
	
	
	@Override
	public List<Map<String, Object>> getCompanyRepairExcelList(CommandMap paramMap) throws Exception {
		return companyDao.getCompanyRepairExcelList(paramMap);
	}
}
