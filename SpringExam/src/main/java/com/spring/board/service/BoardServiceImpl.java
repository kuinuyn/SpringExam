package com.spring.board.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.board.dao.BoardDao;
import com.spring.board.vo.BoardVO;
import com.spring.common.vo.FilesVO;
import com.spring.common.CommandMap;
import com.spring.common.util.PagingUtil;
import com.spring.common.util.ResultUtil;

@Service
public class BoardServiceImpl implements BoardService{
	@Autowired
	private BoardDao boardDao;
	
//	@Override
//	public List<BoardVO> getBoardList() throws Exception {
//		return boardDao.getBoardList();
//	}
	
	@Override
	public ResultUtil getBoardList(BoardVO boardVo) throws Exception {
		ResultUtil resultUtil = new ResultUtil();
		
		int totalCount = boardDao.getBoardCnt();
		CommandMap map = new CommandMap();
		
		if(totalCount > 0) {
			map.put("total_list_count", totalCount);
			map.put("current_page_no", String.valueOf(boardVo.getCurrent_page_no()));
			map.put("function_name", boardVo.getFunction_name());
			boardVo.setCount_per_page(10);
			boardVo.setCount_per_list(10);
			boardVo.setTotal_list_count(totalCount);
			
			map = PagingUtil.setPageUtil(map);
			boardVo.setLimit((Integer) map.get("limit"));
			boardVo.setOffset((Integer) map.get("offset"));
			//boardVo = (BoardVO) PagingUtil.setPageUtil(boardVo);
		}
		
		List<BoardVO> list = boardDao.getBoardList(boardVo);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", list);
		resultMap.put("totalCount", totalCount);
		resultMap.put("pagination", boardVo.getPagination());
		
		resultUtil.setData(resultMap);
		resultUtil.setState("SUCCESS");
		
		return resultUtil;
	}

	/** 게시판 - 상세 조회 */
	@Override
	public BoardVO getBoardDetail(BoardVO vo) throws Exception {

		BoardVO boardVo = new BoardVO();

		String searchType = vo.getSearch_type();

		if("S".equals(searchType)){
			
			int updateCnt = boardDao.updateBoardHits(vo);
		
			if (updateCnt > 0) {
				boardVo = boardDao.getBoardDetail(vo);
			}
			
		}
		
		boardVo = boardDao.getBoardDetail(vo);
		
		FilesVO filesVo = new FilesVO();
		filesVo.setSeq(String.valueOf(boardVo.getBoard_seq()));
		
		boardVo.setDownloadFiles(boardDao.getBoardFileList(filesVo));
		
		return boardVo;
	}

	/** 게시판 - 등록 */
	@Override
	public BoardVO insertBoard(BoardVO vo) throws Exception {

		BoardVO boardVo = new BoardVO();

		int boardReRef = boardDao.getBoardReRef(vo);
		vo.setBoard_re_ref(boardReRef);
		
		int insertCnt = boardDao.insertBoard(vo);
		
		List<FilesVO> boardFileList = getBoardFileInfo(vo); 
		for(FilesVO files : boardFileList) {
			boardDao.insertBoardFile(files);
		}
		
		if (insertCnt > 0) {
			boardVo.setResult("SUCCESS");
		} else {
			boardVo.setResult("FAIL");
		}

		return boardVo;
	}
	
	/** 게시판 - 첨부파일 정보 조회 */
	public List<FilesVO> getBoardFileInfo(BoardVO boardVo) throws Exception {
		List<MultipartFile> files = boardVo.getFiles();
		List<FilesVO> boardFileList = new ArrayList<FilesVO>();
		
		FilesVO fileVo = new FilesVO();
		
		int seq = boardVo.getBoard_seq();
		String fileName = null;
		String fileExt = null;
		String fileNameKey = null;
		String fileSize = null;
		// 파일이 저장될 Path 설정
		String filePath = "c:\\upload\\board";
		
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
				fileVo.setSeq(String.valueOf(seq));
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
	
	/** 게시판 - 삭제 */
	@Override
	public BoardVO deleteBoard(BoardVO vo) throws Exception {

		BoardVO boardDto = new BoardVO();

		int deleteCnt = boardDao.deleteBoard(vo);

		if (deleteCnt > 0) {
			boardDto.setResult("SUCCESS");
		} else {
			boardDto.setResult("FAIL");
		}

		return boardDto;
	}

	/** 게시판 - 수정 */
	@Override
	public BoardVO updateBoard(BoardVO vo) throws Exception {

		BoardVO boardDto = new BoardVO();
		int updateCnt = boardDao.updateBoard(vo);
		
		String deleteFile = vo.getDelete_file();
		if(!"".equals(deleteFile)) {
			String[] deleteFileInfo = deleteFile.split("!");
			
			FilesVO filesVo = new FilesVO();
			filesVo.setSeq(deleteFileInfo[0]);
			filesVo.setFile_no(Integer.parseInt(deleteFileInfo[1]));
			
			boardDao.deleteBoardFile(filesVo);
		}
		
		List<FilesVO> boardFileList = getBoardFileInfo(vo); 
		for(FilesVO files : boardFileList) {
			boardDao.insertBoardFile(files);
		}

		if (updateCnt > 0) {
			boardDto.setResult("SUCCESS");
		} else {
			boardDto.setResult("FAIL");
		}

		return boardDto;
	}
	
	/**
	 * 게시판 엑셀 다운로드
	 */
	@Override
	public List<Map<String, Object>> getExcelDownloadList() throws Exception {
		List<Map<String, Object>> excelDownloadList = new ArrayList<Map<String,Object>>();
		excelDownloadList = boardDao.getExcelDownloadList();
		
		return excelDownloadList;
	}
}
