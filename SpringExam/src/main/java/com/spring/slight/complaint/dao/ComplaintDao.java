package com.spring.slight.complaint.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class ComplaintDao {
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	private final static String NAMESPACE = "com.spring.mapper.slight.complaint.complaintMapper";
	
	public int getComplaintCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getComplaintCnt", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getComplaintList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getComplaintList", paramMap.getMap());
		return resultList;
	}
	
	public Map<String, Object> getComplaintDetail(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getComplaintDetail", paramMap.getMap());
		return resultMap;
	}
}
