package com.spring.common.web;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.spring.common.service.FileService;
import com.spring.common.util.MediaUtils;
import com.spring.common.vo.FilesVO;

@Controller
public class FileController {
	@Resource(name="FileService")
	private FileService fileService;
	
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
}
