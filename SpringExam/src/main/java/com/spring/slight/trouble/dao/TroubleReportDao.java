package com.spring.slight.trouble.dao;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class TroubleReportDao {
	
	private static final String NAMESPACE = "com.spring.mapper.trouble.troubleMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public int insertTrobleReport(CommandMap paramMap) throws Exception {
		
		int cnt = sqlSession.insert(NAMESPACE+".insertTrobleReport", paramMap.getMap());
		
		return cnt;
	}
}
