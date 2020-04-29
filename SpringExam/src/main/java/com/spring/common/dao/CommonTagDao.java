package com.spring.common.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class CommonTagDao {
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.spring.mapper.common.commonTagMapper";
	
	public List<Map<String, Object>> getCodeList() throws Exception {
		List<Map<String, Object>> codeList = new ArrayList<Map<String,Object>>();
		
		codeList = sqlSession.selectList(NAMESPACE+".getCodeList");
		return codeList;
	}
}
