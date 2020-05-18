package com.spring.common.dao;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.vo.FilesVO;

@Repository
public class FileDao {
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.spring.mapper.common.filesMapper";
	
	public List<FilesVO> getFilesList(FilesVO vo) throws Exception {
		return sqlSession.selectList(NAMESPACE+".getFilesList", vo);
	}
	
	public int deleteFiles(FilesVO vo) throws Exception {
		return sqlSession.update(NAMESPACE+".deleteFiles", vo);
	}
	
	public int deleteFile(FilesVO vo) throws Exception {
		return sqlSession.update(NAMESPACE+".deleteFile", vo);
	}
	
	public int insertFiles(FilesVO vo) throws Exception {
		return sqlSession.insert(NAMESPACE+".insertFiles", vo);
	}
}
