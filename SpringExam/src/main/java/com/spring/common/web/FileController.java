package com.spring.common.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.service.FileService;
import com.spring.common.util.MediaUtils;
import com.spring.common.vo.FilesVO;

@Controller
@PropertySource("classpath:/properties/app_config.properties")
public class FileController {
	@Resource(name="FileService")
	private FileService fileService;
	
	@Value("${file.upload.path}")
	private String path;
	
	@RequestMapping(value="/display", method=RequestMethod.GET)
	public ResponseEntity<byte[]> displayFile(@RequestParam("name") String fileName) {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		try {
			FilesVO vo = new FilesVO();
			vo.setFile_name_key(fileName);
			vo = fileService.getFiles(vo);
			
			String formatName = vo.getFile_name().substring(vo.getFile_name().lastIndexOf(".")+1);
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();
			in = new FileInputStream(vo.getFile_path().concat("/").concat(vo.getFile_name_key()));
			
			if(mType != null) {
				headers.setContentType(mType);
			}
			
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		}
		catch (Exception e) {
			e.printStackTrace();
			
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@RequestMapping(value="/filesList")
	public ModelAndView getFilesList(HttpServletRequest reuqest, FilesVO filesVo) {
		ModelAndView mv = new ModelAndView();
		List<FilesVO> resultList = new ArrayList<FilesVO>();
		try {
			resultList = fileService.getFilesList(filesVo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		mv.addObject("resultData", resultList);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	//다음에디터 파일 업로드
	@RequestMapping(value="/daumEditorImageUpload")
	public @ResponseBody HashMap<String, Object> daumEditorImageUpload(@RequestParam("Filedata") MultipartFile multipartFile, HttpSession session) {
		HashMap<String, Object> fileInfo = new HashMap<String, Object>();
		String originalName = "";
		String originalNameExtension = "";
		
		// 업로드 파일이 존재하면 
		if(multipartFile != null && !(multipartFile.getOriginalFilename().equals(""))) {
			// 확장자 제한 
			originalName = multipartFile.getOriginalFilename(); // 실제 파일명
			originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase(); // 실제파일 확장자 (소문자변경) 
			if( !( (originalNameExtension.equals("jpg")) || (originalNameExtension.equals("gif")) || (originalNameExtension.equals("png")) || (originalNameExtension.equals("bmp")) ) ){ 
				fileInfo.put("result", -1); // 허용 확장자가 아닐 경우 
				return fileInfo; 
			}
		
			// 파일크기제한(1MB)
			long fileSize = multipartFile.getSize(); //파일크기
			long limitFileSize = 1*1024*1024; //1MB
			if(limitFileSize < fileSize) {
				fileInfo.put("result", -2); // 제한보다 파일크기가 클 경우
				return fileInfo; 
			}
			
			//저장경로
			String defaultPath = session.getServletContext().getRealPath("/");
			String path = defaultPath+this.path+File.separator+"daum"+File.separator+"image"+File.separator;
			
			// 저장경로 처리 
			File file = new File(path);
			if(!file.exists()) {
				// 디렉토리 존재하지 않을경우 디렉토리 생성 
				file.mkdirs();
			}
	
			// 파일 저장명 처리 (20150702091941-fd8-db619e6040d5.확장자)
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss"); 
			String today= formatter.format(new Date()); 
			String modifyName = today + "-" + UUID.randomUUID().toString().substring(20) + "." + originalNameExtension;
			
			try {
				multipartFile.transferTo(new File(path + modifyName));
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			
			// CallBack - Map에 담기
			String imageurl = session.getServletContext().getContextPath()+"/"+ this.path + "/daum/image/" + modifyName; // separator와는 다름!
			fileInfo.put("imageurl", imageurl); // 상대파일경로(사이즈변환이나 변형된 파일)
			fileInfo.put("filename", modifyName); // 파일명
			fileInfo.put("filesize", fileSize); // 파일사이즈
			fileInfo.put("imagealign", "C"); // 이미지정렬(C:center)
			fileInfo.put("originalurl", imageurl); // 실제파일경로
			fileInfo.put("thumburl", imageurl); // 썸네일파일경로(사이즈변환이나 변형된 파일)
	
			fileInfo.put("result", 1); // -1, -2를 제외한 아무거나 싣어도 됨
		}
		return fileInfo;
	}
}
