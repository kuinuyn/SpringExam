package com.spring.slight.system.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class SystemMemberDao {
	
	private static final String NAMESPACE = "com.spring.mapper.slight.system.systemMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public List<Map<String, Object>>getSystemMemberSearchYear() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getSystemMemberSearchYear");
	}
	
	public int getSystemMemberCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getSystemMemberCnt", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getSystemMemberList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemMemberList", paramMap.getMap());
		return resultList;
	}
	
	public Map<String, Object> getSystemMemberDetail(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemMemberDetail", paramMap.getMap());
		return resultMap;
	}
	
	public int chkMemberId(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.selectOne(NAMESPACE+".getDupIdChk", paramMap.getMap());
		return cnt;
	}
	
	public int insertSystemMember(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".insertSystemMember", paramMap.getMap());
		
		return cnt;
	}
	
	public int updateSystemMember(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".updateSystemMember", paramMap.getMap());
		
		return cnt;
	}
	
	public int deleteSystemMember(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".deleteSystemMember", paramMap.getMap());
		
		return cnt;
	}
}
