package com.spring.slight.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class MainDao {
	
	private static final String NAMESPACE = "com.spring.mapper.slight.mainMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public List<Map<String, Object>> getSummary(CommandMap paramMap) throws Exception {
		
		return sqlSession.selectList(NAMESPACE+".getSummary", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getLastSummary(Map<String, Object> paramMap) throws Exception {
		
		return sqlSession.selectList(NAMESPACE+".getLastSummary", paramMap);
	}
	
	public int getLightCnt(CommandMap paramMap) throws Exception {
		
		return sqlSession.selectOne(NAMESPACE+".getLightCnt", paramMap.getMap());
	}
}
