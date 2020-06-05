package com.spring.slight.repair.service;

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
import com.spring.slight.repair.dao.RepairDao;
import com.spring.slight.system.dao.SystemMemberDao;

@Service("RepairService")
public class RepairServiceImpl implements RepairService{
	@Autowired
	private RepairDao repairDao;
	
	@Autowired
	private FileDao fileDao;
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@Autowired
	private SystemMemberDao systemMemberDao;
	
	@Autowired
	private SmsSendDao smsSendDao;
	
	@Override
	public List<Map<String, Object>> getSystemRepairSearchCom() throws Exception {
		return repairDao.getSystemRepairSearchCom();
	}
	
	@Override
	public List<Map<String, Object>> getSystemRepairSearchYear() throws Exception {
		return repairDao.getSystemRepairSearchYear();
	}	

	@Override
	public ResultUtil getSystemRepairList(CommandMap paramMap) throws Exception {
		ResultUtil result = new ResultUtil();
		int totalCount = repairDao.getSystemRepairCnt(paramMap);
		
		if(totalCount > 0) {
			paramMap.put("total_list_count", totalCount);
			
			paramMap = PagingUtil.setPageUtil(paramMap);
		}
		
		List<Map<String, Object>> list = repairDao.getSystemRepairList(paramMap);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", paramMap.get("pagination"));
		
		result.setData(resultMap);
		result.setState("SUCCESS");
		
		return result;
	}

	@Override
	public Map<String, Object> getSystemRepairDetail(CommandMap paramMap) throws Exception {
		Map<String, Object> resultData = repairDao.getSystemRepairDetail(paramMap);
		
		FilesVO filesVo = new FilesVO();
		filesVo.setSeq((String) paramMap.get("repairNo"));
		List<FilesVO> filesList = fileDao.getFilesList(filesVo);
		
		if(resultData != null) {
			String noticeDate = "";
			String companyId = "";

			noticeDate = (String) resultData.get("notice_date");
			companyId = (String) resultData.get("company_id");
			
			paramMap.put("noticeDate", noticeDate);
			paramMap.put("company_id", companyId);
			List<Map<String, Object>> materiaList = repairDao.getMaterialList(paramMap);
			List<Map<String, Object>> materiaUsedList = repairDao.getMaterialUsedList(paramMap);
			
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

	@Override
	public List<Map<String, Object>> getSystemRepairExcelList(CommandMap paramMap) throws Exception {
		return repairDao.getSystemRepairExcelList(paramMap);
	}
	
	@Override
	public int updateRepair(CommandMap paramMap) throws Exception {
		int resultCnt = repairDao.updateRepair(paramMap);
		int cnt = 0;
		String saveFlag = "";
		if(repairDao.getSystemRepairSaveFlag(paramMap) == null) {
			saveFlag = "I";
		}
		else {
			saveFlag = (String) repairDao.getSystemRepairSaveFlag(paramMap).get("saveflag");
		}
		
		
		if(resultCnt > 0) {
			if("I".equals(saveFlag)) {
				cnt = repairDao.insertRepairPart(paramMap);			
			} else if("U".equals(saveFlag)){
				paramMap.put("repairNo", paramMap.get("repair_no"));
				cnt = repairDao.updateRepairPart(paramMap);	
				repairDao.deleteRepairMaterialCancel(paramMap);
				FilesVO filesVo = new FilesVO();
				filesVo.setSeq((String) paramMap.get("repair_no"));
				fileDao.deleteFiles(filesVo);
			} else {
				cnt = repairDao.insertRepairPart(paramMap);			
			}
			
			CommandMap smsMsg = new CommandMap();
			PropertiesUtils propertiesUtils = new PropertiesUtils();
			propertiesUtils.loadProp("/properties/app_config.properties");
			Properties properties = propertiesUtils.getProperties();
			smsMsg.put("memberId", properties.getProperty("domin.id"));
			Map<String, Object> companyInfo = systemMemberDao.getSystemMemberDetail(smsMsg);
			Map<String, Object> resultStatus = repairDao.getRepairStatus(paramMap);
			smsMsg.put("memberId", paramMap.get("searchCom1"));
			Map<String, Object> revInfo = systemMemberDao.getSystemMemberDetail(smsMsg);
			
			paramMap.putAll(resultStatus);
			smsMsg.put("notice_name", resultStatus.get("notice_name"));
			smsMsg.put("mobile", revInfo.get("mobile"));
			smsMsg.put("jisaNum", companyInfo.get("phone"));
			smsMsg.put("groupDomain", properties.getProperty("domin.groupDomain"));
			smsMsg.put("msg", SmsMsgUtil.setSmsMsg(paramMap));
			smsSendDao.insertSmsSend(smsMsg);
		}
		
		return resultCnt+cnt;
	}

	@Override
	public int updateRepairCancel(CommandMap paramMap) throws Exception {
		int resultCnt = repairDao.updateRepairCancel(paramMap);
		
		if(resultCnt > 0) {
			repairDao.deleteRepairCancel(paramMap);
			repairDao.deleteRepairMaterialCancel(paramMap);
			FilesVO filesVo = new FilesVO();
			filesVo.setSeq((String) paramMap.get("repairNo"));
			fileDao.deleteFiles(filesVo);
		}
		
		return resultCnt;
	}

	@Override
	public int updateRepairDetail(CommandMap paramMap, List<MultipartFile> paramFiles) throws Exception {
		String progressStatus = (String) repairDao.getRepairStatus(paramMap).get("progress_status");
		
		if("04".equals(progressStatus)) {
			return -2;
		}
		
		int resultCnt = repairDao.updateRepairDetail(paramMap);
		
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
		
		int resultCnt2 = repairDao.updateRepairDetailPart(paramMap);
		
		HashMap<String, Object> materialUsedMap = new HashMap<String, Object>();
		
		String partCd = (String) paramMap.get("part_cd");
		String partCnt = (String) paramMap.get("part_cnt");
		
		if(partCd != null && !"".equals(partCd)) {
			String[] partCds = partCd.split(",");
			String[] partCnts = partCnt.split(",");
			
			if(partCds.length > 0) {
				for(int i=0; i<partCds.length; i++) {
					
					paramMap.put("part_cd", partCds[i]);
					paramMap.put("inout_cnt", Integer.parseInt(partCnts[i]));
					materialUsedMap = repairDao.getMaterialUsedMap(paramMap);
					
					if(Integer.parseInt(partCnts[i]) != 0) {
						
						if(materialUsedMap != null) {
							paramMap.put("seq_no", materialUsedMap.get("seq_no"));
							paramMap.put("inout_day", materialUsedMap.get("inout_day"));
							
							repairDao.updateMaterialUsed(paramMap);
						}
						else {
							repairDao.insertMaterialUsed(paramMap);
						}
					}
					else {
						paramMap.put("seq_no", materialUsedMap.get("seq_no"));
						paramMap.put("inout_day", materialUsedMap.get("inout_day"));
						
						repairDao.deleteMaterialUsed(paramMap);
					}
				}
				
			}
		}
		
		Map<String, Object> resultStatus = repairDao.getRepairStatus(paramMap);
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
		
		return resultCnt+resultCnt2;
	}
	
}
