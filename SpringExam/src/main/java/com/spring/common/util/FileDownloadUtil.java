package com.spring.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadUtil extends AbstractView{
	
	public FileDownloadUtil() {
		setContentType("application/download; charset=utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, Object> fileInfo = (Map<String, Object>) model.get("fileInfo");
		
		String fileNameKey = (String) fileInfo.get("fileNameKey");
		String fileName = (String) fileInfo.get("fileName");
		String filePath = (String) fileInfo.get("filePath");
		
		File file = new File(filePath, fileNameKey);
		
		response.setContentType(getContentType());
		response.setContentLength((int) file.length());
		
		//브라우저, 운영체제정보
		String userAgent = request.getHeader("User-Agent");
		
		//IE
		if(userAgent.indexOf("MSIE") > -1) {
			fileName = URLEncoder.encode(fileName, "UTF-8");
		}
		
		//IE
		if(userAgent.indexOf("Trident") > -1) {
			fileName = URLEncoder.encode(fileName, "UTF-8");
		}
		else {
			fileName = URLEncoder.encode(fileName, "8859_1");
		}
		
		response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		}
		finally {
			if(fis != null) {
				fis.close();
			}
		}
		
		out.flush();
	}
	
	/**
	 * 엑셀 워크북 객체로 생성
	 */
	public SXSSFWorkbook makeSimpleExcelWorkbook(List<Map<String, Object>> list, String[] headerNm) {
		SXSSFWorkbook workbook = new SXSSFWorkbook();
		
		//시트생성
		SXSSFSheet sheet = workbook.createSheet();
		
		//행 생성
		int row = 0;
		Row headerRow = sheet.createRow(row);
		Cell headerCell = null;
		
		Row bodyRow = null;
		Cell bodyCell = null;
		String val = "";
		for(int i=0; i<list.size(); i++) {
			row++;
			for(int j=0; j<headerNm.length; j++) {
				if(j == 0) {
					bodyRow = sheet.createRow(row);
				}
				
				if(i == 0) {
					headerCell = headerRow.createCell(j);
					headerCell.setCellValue(headerNm[j]);
					
					bodyCell = bodyRow.createCell(j);
					val = String.valueOf(list.get(i).get(headerNm[j]));
					bodyCell.setCellValue(val);
				}
				else {
					
					bodyCell = bodyRow.createCell(j);
					val = String.valueOf(list.get(i).get(headerNm[j]));
					bodyCell.setCellValue(val);
				}
			}
		}
		
		return workbook;
	}
}
