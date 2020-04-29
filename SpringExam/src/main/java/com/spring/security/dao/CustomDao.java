package com.spring.security.dao;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.security.vo.CustomVO;

@Repository
public class CustomDao {
	
	private static final String NAMESPACE = "com.spring.mapper.slight.customMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public int getCustomerCnt(CustomVO vo) throws Exception {
		
		int cnt = sqlSession.selectOne(NAMESPACE+".getCustomerCnt");
		
		return cnt;
	}
}
