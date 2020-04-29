package com.spring.common.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class MapDao {
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.spring.mapper.common.mapMapper";
	
	public List<Map<String, Object>> resultData(Map<String, Object> paramMap) throws Exception {
		List<Map<String, Object>> resultData = sqlSession.selectList(NAMESPACE+".getMapDataList", paramMap);
		return resultData;
	}
}
