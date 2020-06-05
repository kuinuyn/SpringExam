package com.spring.common.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.vo.FilesVO;

public class FileUploadUtil {
	/** 게시판 - 첨부파일 정보 조회 */
	public static List<FilesVO> setFileUploadUtil(List<MultipartFile> files, String seq, String folderNm) throws Exception {
		List<FilesVO> boardFileList = new ArrayList<FilesVO>();
		
		FilesVO fileVo = new FilesVO();
		
		PropertiesUtils propertiesUtils = new PropertiesUtils();
		propertiesUtils.loadProp("/properties/app_config.properties");
		Properties properties = propertiesUtils.getProperties();
		
		String fileName = null;
		String fileExt = null;
		String fileNameKey = null;
		String fileSize = null;
		// 파일이 저장될 Path 설정
		String filePath = properties.getProperty("file.upload.path")+folderNm;
		
		if(files != null && files.size() > 0) {
			File file = new File(filePath);
			
			if(!file.exists()) {
				file.mkdirs();
			}
			
			for(MultipartFile multipartFile : files) {
				fileName = multipartFile.getOriginalFilename();
				fileExt = fileName.substring(fileName.lastIndexOf("."));
				// 파일명 변경(uuid로 암호화)+확장자
				fileNameKey = getRandomString()+fileExt;
				fileSize = String.valueOf(multipartFile.getSize());
				
				// 설정한 Path에 파일 저장
				file = new File(filePath+"/"+fileNameKey);
				
				multipartFile.transferTo(file);
				
				fileVo = new FilesVO();
				fileVo.setSeq(seq);
				fileVo.setFile_name(fileName);
				fileVo.setFile_name_key(fileNameKey);
				fileVo.setFile_path(filePath);
				fileVo.setFile_size(fileSize);
				
				boardFileList.add(fileVo);
			}
		}
		
		return boardFileList;
	}
	
	/** 32글자의 랜덤한 문자열(숫자포함) 생성*/
	public static String getRandomString() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}

}
