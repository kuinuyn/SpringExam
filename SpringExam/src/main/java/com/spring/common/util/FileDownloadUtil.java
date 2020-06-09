package com.spring.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
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
		
		//Î∏åÎùº?ö∞??, ?ö¥?òÅÏ≤¥Ï†ú?†ïÎ≥?
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
	 * ?óë?? ?õå?Å¨Î∂? Í∞ùÏ≤¥Î°? ?Éù?Ñ±
	 */
	@SuppressWarnings("unchecked")
	public SXSSFWorkbook makeSimpleExcelWorkbook(List<?> list, String[] headerNm) {
		SXSSFWorkbook workbook = new SXSSFWorkbook();
		
		//?ãú?ä∏?Éù?Ñ±
		SXSSFSheet sheet = workbook.createSheet();
		CellStyle style = workbook.createCellStyle();
		//?Öå?ëêÎ¶? ?Ñ† (?ö∞,Ï¢?,?úÑ,?ïÑ?ûò)
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		
		style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		
		//?ñâ ?Éù?Ñ±
		int row = 0;
		Row headerRow = sheet.createRow(row++);
		Cell headerCell = null;
		
		Row bodyRow = null;
		Cell bodyCell = null;
		String val = "";
		for(int j=0; j<headerNm.length; j++) {
			headerCell = headerRow.createCell(j);
			headerCell.setCellValue(headerNm[j]);
			headerCell.setCellStyle(style);
		}
		
		style = workbook.createCellStyle();
		//?Öå?ëêÎ¶? ?Ñ† (?ö∞,Ï¢?,?úÑ,?ïÑ?ûò)
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		
		for(int i=0; i<list.size(); i++) {
			for(int j=0; j<headerNm.length; j++) {
				if(j == 0) {
					bodyRow = sheet.createRow(row++);
				}
				
				bodyCell = bodyRow.createCell(j);
				val = String.valueOf(((Map<String, Object>) list.get(i)).get(headerNm[j]));
				bodyCell.setCellValue(val);
				bodyCell.setCellStyle(style);
			}
		}
		
		return workbook;
	}
}
