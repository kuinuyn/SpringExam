package com.spring.board.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.board.vo.BoardVO;
import com.spring.common.util.ResultUtil;
import com.spring.common.util.FileDownloadUtil;
import com.spring.board.service.BoardService;

@Controller
@RequestMapping(value = "/board")
public class BoardController {

	@Autowired
	private BoardService boardService;

	/** 게시판 - 목록 페이지 이동 */
	@RequestMapping( value = "/board")
	public String boardList(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		return "board/board";
	}
		
	/** 게시판 - 목록 조회  */
	@RequestMapping(value = "/getBoardList")
	@ResponseBody
	public ResultUtil getBoardList(HttpServletRequest request, HttpServletResponse response, BoardVO boardVo) throws Exception {

//		List<BoardVO> boardVoList = boardService.getBoardList();

		ResultUtil result = boardService.getBoardList(boardVo);
		
		return result;
	}
	
	/** 게시판 - 상세 페이지 이동 */
	@RequestMapping( value = "/boardDetail")
	public String boardDetail(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		return "board/boardDetail";
	}	
	
	/** 게시판 - 상세 조회  */
	@RequestMapping(value = "/getBoardDetail")
	@ResponseBody
	public BoardVO getBoardDetail(HttpServletRequest request, HttpServletResponse response, BoardVO boardVo) throws Exception {

		BoardVO boardDto = boardService.getBoardDetail(boardVo);

		return boardDto;
	}
	
	/** 게시판 - 작성 페이지 이동 */
	@RequestMapping( value = "/boardWrite")
	public String boardWrite(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		return "board/boardWrite";
	}
	
	/** 게시판 - 작성 페이지 이동 (ckeditor 추가) */
	@RequestMapping( value = "/boardEditorWrite")
	public String boardEditorWrite(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		return "board/boardEditorWrite";
	}
	
	/** 게시판 - 등록 */
	@RequestMapping( value = "/insertBoard")
	@ResponseBody
	public BoardVO insertBoard(HttpServletRequest request, HttpServletResponse response, BoardVO boardVo) throws Exception{
		
		BoardVO boardDto = boardService.insertBoard(boardVo);
		
		return boardDto;
	}
	
	/** 게시판 - 삭제 */
	@RequestMapping( value = "/deleteBoard")
	@ResponseBody
	public BoardVO deleteBoard(HttpServletRequest request, HttpServletResponse response, BoardVO boardVo) throws Exception{
		
		BoardVO boardDto = boardService.deleteBoard(boardVo);
		
		return boardDto;
	}
	
	/** 게시판 - 수정 페이지 이동 */
	@RequestMapping( value = "/boardUpdate")
	public String boardUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		return "board/boardUpdate";
	}
	
	/** 게시판 - 수정 */
	@RequestMapping( value = "/updateBoard")
	@ResponseBody
	public BoardVO updateBoard(HttpServletRequest request, HttpServletResponse response, BoardVO boardVo) {
		
		BoardVO resultVo = new BoardVO();
		try {
			resultVo = boardService.updateBoard(boardVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultVo;
	}
	
	/** 게시판 - 첨부파일 다운로드 */
	@RequestMapping(value="/fileDownload")
	public ModelAndView fileDownload(@RequestParam("fileNameKey") String fileNameKey
																, @RequestParam("fileName") String fileName
																, @RequestParam("filePath") String filePath
																) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> fileInfo = new HashMap<String, Object>();
		fileInfo.put("fileNameKey", fileNameKey);
		fileInfo.put("fileName", fileName);
		fileInfo.put("filePath", filePath);
		
		mv.setViewName("fileDownloadUtil");
		mv.addObject("fileInfo", fileInfo);
		return mv;
	}
	
	/** 엑셀 다운로드 **/
	@RequestMapping(value="/downloadExcel")
	public String downloadExcelFile(Model model, HttpServletRequest request) {
		String[] headerNm = request.getParameter("excelHeader").split(",");
		FileDownloadUtil fileUtil = new FileDownloadUtil();
		try {
			SXSSFWorkbook workbook = fileUtil.makeSimpleExcelWorkbook(boardService.getExcelDownloadList(), headerNm);
			model.addAttribute("locale", Locale.KOREA);
			model.addAttribute("workbook", workbook);
			model.addAttribute("workbookName", "게시판");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "excelDownloadView";
	}
}
