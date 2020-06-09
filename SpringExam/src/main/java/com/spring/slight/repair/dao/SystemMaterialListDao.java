package com.spring.slight.repair.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class SystemMaterialListDao {
private static final String NAMESPACE = "com.spring.mapper.slight.repair.systemMaterialListMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	//년도 가져오기
	public List<Map<String, Object>>getMaterialSearchYear() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getMaterialSearchYear");
	}
	
	//자재관리 총건수
		public int getSystemMaterialCnt(CommandMap paramMap) throws Exception {
			return sqlSession.selectOne(NAMESPACE+".getSystemMaterialCnt", paramMap.getMap());
		}
		
	
	//자재관리 조회
		public List<Map<String, Object>> getSystemMaterialList(CommandMap paramMap) throws Exception {
			List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemMaterialList", paramMap.getMap());
			return resultList;
		}		
	
	
	
	
	//자재관리 상세조회
	public HashMap<String, Object> getSystemMaterialDetail(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemMaterialDetail", paramMap.getMap());
		return resultMap;
	}
	
	
	
	
	public int insertSystemMaterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".insertSystemMaterial", paramMap.getMap());
		
		return cnt;
	}
	
	public int updateSystemMaterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".updateSystemMaterial", paramMap.getMap());
		
		return cnt;
	}
	
	public int deleteSystemMaterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".deleteSystemMaterial", paramMap.getMap());
		
		return cnt;
	}
	
	
	
	
}
