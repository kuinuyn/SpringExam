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
		
		System.out.println("@@@@sch_repair_cd : "+  (String) paramMap.get("sch_repair_cd"));
		System.out.println("@@@@sch_where1 : "+  (String) paramMap.get("sch_where1"));
		System.out.println("@@@@sch_where2 : "+  (String) paramMap.get("sch_where2"));
		System.out.println("@@@@sch_where3 : "+  (String) paramMap.get("sch_where3"));
		
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
		System.out.println("!!!!! : " +paramMap.get("repairNo"));
		List<FilesVO> filesList = fileDao.getFilesList(filesVo);
		//List<Map<String, Object>> detRepirList = companyDao.getDetRepirList(paramMap);
		if(filesList.size() > 0) {
			resultData.put("downLoadFiles", filesList);
		}
		//if(detRepirList.size() > 0) {
			//resultData.put("detRepirList", detRepirList);
		//}
		
		return resultData;
	}

	@Override
	public int updateCompanyRepair(CommandMap paramMap, List<MultipartFile> paramFiles) throws Exception {
		
	
		int resultCnt = companyDao.updateCompanyRepair(paramMap);
		
		String deleteFile = (String) paramMap.get("delete_file");
		
		System.out.println("@@@@deleteFile : "+ deleteFile);
		
		
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
		
		List<FilesVO> files = FileUploadUtil.setFileUploadUtil(paramFiles, (String) paramMap.get("repairNo"));
		
		//FilesVO file1 = files.;
		
		
		for(FilesVO file : files) {
			System.out.println("######## : " + file.getFile_name_key()  );
			System.out.println("######## : " + file.getFile_path()  );
			System.out.println("######## : " + file.getFile_name()  );
			System.out.println("######## : " + file.getFile_no());
			
			fileDao.insertFiles(file);			
		}
		
		
		int resultCnt2 = companyDao.updateCompanyRepairPart(paramMap);
		return resultCnt;
	}
	
	
	@Override
	public List<Map<String, Object>> getCompanyRepairExcelList(CommandMap paramMap) throws Exception {
		return companyDao.getCompanyRepairExcelList(paramMap);
	}
}
