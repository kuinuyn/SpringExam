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
	
	public Map<String, Object> getComplaintStatus(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getComplaintStatus", paramMap.getMap());
		return resultMap;
	}
	
	public String getComplaintRoleChk(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getComplaintRoleChk", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getComplaintStatusCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectList(NAMESPACE+".getComplaintStatusCnt", paramMap.getMap());
	}
	
	public int updateComplaint(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateComplaint", paramMap.getMap());
	}
	
	public int deleteComplaint(CommandMap paramMap) throws Exception {
		return sqlSession.delete(NAMESPACE+".deleteComplaint", paramMap.getMap());
	}
}
