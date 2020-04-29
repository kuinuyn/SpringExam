package com.spring.board.service;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.BoardVO;
import com.spring.common.util.ResultUtil;

public interface BoardService {
	public ResultUtil getBoardList(BoardVO boardVo) throws Exception;
//	public List<BoardVO> getBoardList() throws Exception;
	public BoardVO insertBoard(BoardVO vo) throws Exception;
	public BoardVO deleteBoard(BoardVO vo) throws Exception;
	public BoardVO updateBoard(BoardVO vo) throws Exception;
	public BoardVO getBoardDetail(BoardVO vo) throws Exception;
	public List<Map<String, Object>> getExcelDownloadList() throws Exception;
}
