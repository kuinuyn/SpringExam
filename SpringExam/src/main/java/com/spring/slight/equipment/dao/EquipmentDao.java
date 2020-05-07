package com.spring.slight.equipment.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class EquipmentDao {
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	private final static String NAMESPACE = "com.spring.mapper.slight.equipmentMapper";
	
	public int getEquipmentCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getEquipmentCnt", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getEquipmentList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getEquipmentList", paramMap.getMap());
		
		return resultList;
	}
	
	public HashMap<String, Object> getEquipmentDet(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getEquipmentDet", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<Map<String, Object>> getDetRepirList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getDetRepirList", paramMap.getMap());
		
		return resultMap;
	}
	
	public int updateEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateEquipment", paramMap.getMap());
	}
	
	public int deleteEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".deleteEquipment", paramMap.getMap());
	}
}
