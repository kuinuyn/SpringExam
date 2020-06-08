package com.spring.slight.company.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.common.CommandMap;
import com.spring.common.dao.FileDao;
import com.spring.common.dao.SmsSendDao;
import com.spring.common.util.FileUploadUtil;
import com.spring.common.util.MailSendUtil;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.PropertiesUtils;
import com.spring.common.util.ResultUtil;
import com.spring.common.util.SmsMsgUtil;
import com.spring.common.vo.FilesVO;
import com.spring.slight.company.dao.CompanyDao;
import com.spring.slight.system.dao.SystemMemberDao;

@Service("CompanyService")
public class CompanyServiceImpl implements CompanyService{
	
	@Autowired
	private CompanyDao companyDao;
	
	@Autowired
	private FileDao fileDao;
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@Autowired
	private SystemMemberDao systemMemberDao;
	
	@Autowired
	private SmsSendDao smsSendDao;
	
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
		
		if(resultData != null) {
			String noticeDate = "";
			String companyId = "";

			noticeDate = (String) resultData.get("notice_date");
			companyId = (String) resultData.get("company_id");
			
			paramMap.put("noticeDate", noticeDate);
			paramMap.put("companyId", companyId);
			List<Map<String, Object>> materiaList = companyDao.getMaterialList(paramMap);
			List<Map<String, Object>> materiaUsedList = companyDao.getMaterialUsedList(paramMap);
			
			if(filesList.size() > 0) {
				resultData.put("downLoadFiles", filesList);
			}
			
			if(materiaList.size() > 0) {
				resultData.put("materialList", materiaList);
			}
			
			if(materiaUsedList.size() > 0) {
				resultData.put("materiaUsedList", materiaUsedList);
			}
		}
		
		return resultData;
	}

	@SuppressWarnings("unused")
	@Override
	public int updateCompanyRepair(CommandMap paramMap, List<MultipartFile> paramFiles) throws Exception {
		
		String progressStatus = (String) companyDao.getRepairStatus(paramMap).get("progress_status");
		
		if("04".equals(progressStatus)) {
			return -2;
		}
		
		int resultCnt = companyDao.updateCompanyRepair(paramMap);
		
		String deleteFile = (String) paramMap.get("delete_file");
		
		String[] deleteFileInfo = new String[3];
		FilesVO filesVo = new FilesVO();
		if(!"".equals(deleteFile)) {
			if(deleteFile.indexOf("|") > -1) {
				String[] deleteFilesInfo = deleteFile.split("\\|");
				for(int i=0; i < deleteFilesInfo.length; i++) {
					deleteFileInfo = deleteFilesInfo[i].split("\\!");
					filesVo.setSeq(deleteFileInfo[0].trim());
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
		int file_no_1 = paramMap.get("file_no_1") == null ? 0 : Integer.parseInt(String.valueOf(paramMap.get("file_no_1")));
		int file_no_2 = paramMap.get("file_no_2") == null ? 0 : Integer.parseInt(String.valueOf(paramMap.get("file_no_2")));
		int file_no_3 = paramMap.get("file_no_3") == null ? 0 : Integer.parseInt(String.valueOf(paramMap.get("file_no_3")));
		
		int cnt = 0;
		for(FilesVO file : files) {
			if(cnt > -1) {
				if(!"".equals(photo1) && photo1 != null && file_no_1 == 0) {
					file.setFile_no(Integer.parseInt(photo1));
					photo1 = "";
				}
				else if(!"".equals(photo2) && photo2 != null && file_no_2 == 0) {
					file.setFile_no(Integer.parseInt(photo2));
					photo2 = "";
				}
				else if(!"".equals(photo3) && photo3 != null && file_no_3 == 0) {
					file.setFile_no(Integer.parseInt(photo3));
					photo3 = "";
				}
			}
			else if(cnt > 0) {
				if(!"".equals(photo2) && photo2 != null && file_no_2 == 0) {
					file.setFile_no(Integer.parseInt(photo2));
					photo2 = "";
				}
				else if(!"".equals(photo3) && photo3 != null && file_no_3 == 0) {
					file.setFile_no(Integer.parseInt(photo3));
					photo3 = "";
				}
			}
			else if(cnt > 1) {
				if(!"".equals(photo3) && photo3 != null && file_no_3 == 0) {
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
		
		HashMap<String, Object> materialUsedMap = new HashMap<String, Object>();
		
		String partCd = (String) paramMap.get("part_cd");
		String partCnt = (String) paramMap.get("part_cnt");
		
		if(partCd != null && !"".equals(partCd)) {
			String[] partCds = partCd.split(",");
			String[] partCnts = partCnt.split(",");
			System.out.println(partCds.length+" -- "+partCnts.length);
			
			if(partCds.length > 0) {
				for(int i=0; i<partCds.length; i++) {
					
					paramMap.put("part_cd", partCds[i]);
					paramMap.put("inout_cnt", Integer.parseInt(partCnts[i]));
					materialUsedMap = companyDao.getMaterialUsedMap(paramMap);
					
					if(Integer.parseInt(partCnts[i]) != 0) {
						
						if(materialUsedMap != null) {
							paramMap.put("seq_no", materialUsedMap.get("seq_no"));
							paramMap.put("inout_day", materialUsedMap.get("inout_day"));
							
							companyDao.updateMaterialUsed(paramMap);
						}
						else {
							companyDao.insertMaterialUsed(paramMap);
						}
					}
					else {
						paramMap.put("seq_no", materialUsedMap.get("seq_no"));
						paramMap.put("inout_day", materialUsedMap.get("inout_day"));
						
						companyDao.deleteMaterialUsed(paramMap);
					}
				}
				
			}
		}
		
		Map<String, Object> resultStatus = companyDao.getRepairStatus(paramMap);
		progressStatus = (String) resultStatus.get("progress_status");
		
		if("04".equals(progressStatus)) {
			CommandMap smsMsg = new CommandMap();
			PropertiesUtils propertiesUtils = new PropertiesUtils();
			propertiesUtils.loadProp("/properties/app_config.properties");
			Properties properties = propertiesUtils.getProperties();
			smsMsg.put("memberId", properties.getProperty("domin.id"));
			Map<String, Object> companyInfo = systemMemberDao.getSystemMemberDetail(smsMsg);
			
			String method = (String) resultStatus.get("inform_method");
			if("02".equals(method)) {
				paramMap.put("email", resultStatus.get("email"));
				paramMap.put("revEmail", companyInfo.get("email"));
				MailSendUtil.mailSend(javaMailSender, paramMap);
			}
			else if("01".equals(method)) {
				
				smsMsg.putAll(resultStatus);
				smsMsg.put("notice_name", resultStatus.get("notice_name"));
				smsMsg.put("mobile", resultStatus.get("mobile"));
				smsMsg.put("jisaNum", companyInfo.get("phone"));
				smsMsg.put("groupDomain", properties.getProperty("domin.groupDomain"));
				smsMsg.put("msg", SmsMsgUtil.setSmsMsg(smsMsg));
				
				smsSendDao.insertSmsSend(smsMsg);
			}
		}
		
		return resultCnt;
	}
	
	
	@Override
	public List<Map<String, Object>> getCompanyRepairExcelList(CommandMap paramMap) throws Exception {
		return companyDao.getCompanyRepairExcelList(paramMap);
	}
}
