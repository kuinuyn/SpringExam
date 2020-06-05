package com.spring.common.dao;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class SmsSendDao {
	@Resource(name="sqlSessionSms")
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.spring.mapper.common.smsMapper";
	
	public int insertSmsSend(CommandMap paramMap) throws Exception {
		return sqlSession.insert(NAMESPACE+".insertSmsSend", paramMap.getMap());
	}
}
