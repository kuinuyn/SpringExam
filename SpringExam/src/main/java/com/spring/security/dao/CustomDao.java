package com.spring.security.dao;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.security.vo.CustomVO;

@Repository
public class CustomDao {
	
	private static final String NAMESPACE = "com.spring.mapper.slight.customMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public Map<String, Object> getCustomerMap(CustomVO vo) throws Exception {
		
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getCustomerMap", vo);
		
		return resultMap;
	}
}
