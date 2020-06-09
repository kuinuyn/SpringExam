package com.spring.slight.repair.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class SystemUseDao {
	
	private static final String NAMESPACE = "com.spring.mapper.slight.repair.systemUseMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public List<Map<String, Object>>getSystemUseSearchYear() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getSystemUseSearchYear");
	}
	
	public List<Map<String, Object>>getSystemUseSearchCom() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getSystemUseSearchCom");
	}

	public List<Map<String, Object>>getSystemUseSearchPart() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getSystemUseSearchPart");
	}
	
	public int getSystemUseCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getSystemUseCnt", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getSystemUseList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemUseList", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getSystemUseView(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemUseView", paramMap.getMap());
		return resultList;
	}	
	
	public Map<String, Object> getSystemUseDetail(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemUseDetail", paramMap.getMap());
		return resultMap;
	}
	
	public Map<String, Object> getSystemUseDetail1(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemUseDetail1", paramMap.getMap());
		return resultMap;
	}
	
	public int insertSystemUse(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".insertSystemUse", paramMap.getMap());
		
		return cnt;
	}
	
	public int updateSystemUse(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".updateSystemUse", paramMap.getMap());
		
		return cnt;
	}
	
	public int deleteSystemUse(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".deleteSystemUse", paramMap.getMap());
		
		return cnt;
	}
}
