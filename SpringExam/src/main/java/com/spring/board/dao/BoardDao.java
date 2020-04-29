package com.spring.board.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.board.vo.BoardVO;
import com.spring.common.vo.FilesVO;

@Repository
public class BoardDao {
	
	@Resource(name="sqlSession")
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.spring.mapper.board.boardMapper";
	
	public List<BoardVO> getBoardList(BoardVO boardVo) throws Exception {
		return sqlSession.selectList(NAMESPACE+".getBoardList", boardVo);
	}
	
	public int getBoardCnt() throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getBoardCnt");
	}
	
	public int updateBoardHits(BoardVO vo) throws Exception {
		return sqlSession.update(NAMESPACE+".updateBoardHits", vo);
	}
	
	public BoardVO getBoardDetail(BoardVO vo) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getBoardDetail", vo);
	}
	
	public int insertBoard(BoardVO vo) throws Exception {
		return sqlSession.insert(NAMESPACE+".insertBoard", vo);
	}
	
	public int deleteBoard(BoardVO vo) throws Exception {
		return sqlSession.delete(NAMESPACE+".deleteBoard", vo);
	}
	
	public int updateBoard(BoardVO vo) throws Exception {
		return sqlSession.update(NAMESPACE+".updateBoard", vo);
	}
	
	public int getBoardReRef(BoardVO vo) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getBoardReRef", vo);
	}
	
	public int insertBoardFile(FilesVO vo) throws Exception {
		return sqlSession.insert(NAMESPACE+".insertBoardFile", vo);
	}
	
	public List<FilesVO> getBoardFileList(FilesVO vo) throws Exception {
		return sqlSession.selectList(NAMESPACE+".getBoardFileList", vo);
	}
	
	public int deleteBoardFile(FilesVO vo) throws Exception {
		return sqlSession.update(NAMESPACE+".deleteBoardFile", vo);
	}
	
	public List<Map<String, Object>> getExcelDownloadList() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getExcelDownloadList");
	}
}
