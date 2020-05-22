package com.spring.slight.equipment.dao;

import java.util.HashMap;
import java.util.LinkedHashMap;
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
	
	public int getChkLightNo(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getChkLightNo", paramMap.getMap());
	}
	
	public List<Map<String, Object>> getDetRepirList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getDetRepirList", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<LinkedHashMap<String, Object>> getEquipHJStaitstice(CommandMap paramMap) throws Exception {
		List<LinkedHashMap<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getEquipHJStaitstice", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<LinkedHashMap<String, Object>> getEquipStandStaitstice(CommandMap paramMap) throws Exception {
		List<LinkedHashMap<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getEquipStandStaitstice", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<LinkedHashMap<String, Object>> getEquipLamp2Staitstice(CommandMap paramMap) throws Exception {
		List<LinkedHashMap<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getEquipLamp2Staitstice", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<LinkedHashMap<String, Object>> getEquipLamp3Staitstice(CommandMap paramMap) throws Exception {
		List<LinkedHashMap<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getEquipLamp3Staitstice", paramMap.getMap());
		
		return resultMap;
	}
	
	public List<LinkedHashMap<String, Object>> getComplaintList(CommandMap paramMap) throws Exception {
		List<LinkedHashMap<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getComplaintList", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getCompanyId(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getCompanyId", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getLightList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getLightList", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getMaterialList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getMaterialList", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getRepairList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getRepairList", paramMap.getMap());
		return resultList;
	}
	
	public List<Map<String, Object>> getMaterialUseList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getMaterialUseList", paramMap.getMap());
		return resultList;
	}
	
	public int updateEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateEquipment", paramMap.getMap());
	}
	
	public int insertGisEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".insertGisEquipment", paramMap.getMap());
	}
	
	public int updateGisEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateGisEquipment", paramMap.getMap());
	}
	
	public int deleteEquipment(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".deleteEquipment", paramMap.getMap());
	}
}
