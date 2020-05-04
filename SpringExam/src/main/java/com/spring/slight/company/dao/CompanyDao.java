package com.spring.slight.company.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class CompanyDao {
private static final String NAMESPACE = "com.spring.mapper.slight.company.companyMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public List<Map<String, Object>>getCompanyInfoSearchYear() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getCompanyInfoSearchYear");
	}
	
	public Map<String, Object> getCompanyInfo(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = sqlSession.selectOne(NAMESPACE+".getCompanyInfo", paramMap.getMap());
		return resultMap;
	}
	
	public int updateCompanyInfo(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".updateCompanyInfo", paramMap.getMap());
		
		return cnt;
	}
}
