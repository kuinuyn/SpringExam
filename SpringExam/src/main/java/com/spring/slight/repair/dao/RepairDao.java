package com.spring.slight.repair.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class RepairDao {
	private static final String NAMESPACE = "com.spring.mapper.slight.repair.repairMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	public int getSystemRepairCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getSystemRepairCnt", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getSystemRepairList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemRepairList", paramMap.getMap());
		return resultList;
	}
	
	public Map<String, Object> getSystemRepairDetail(CommandMap paramMap) throws Exception {
		Map<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemRepairDetail", paramMap.getMap());
		return resultMap;
	}
	
	public List<Map<String, Object>> getSystemRepairExcelList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemRepairExcelList", paramMap.getMap());
		return resultList;
	}
}
