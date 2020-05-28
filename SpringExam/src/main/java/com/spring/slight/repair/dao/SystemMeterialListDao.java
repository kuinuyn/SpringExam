package com.spring.slight.repair.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class SystemMeterialListDao {
private static final String NAMESPACE = "com.spring.mapper.slight.repair.systemMeterialListMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	//년도 가져오기
	public List<Map<String, Object>>getMeterialSearchYear() throws Exception {
		return sqlSession.selectList(NAMESPACE+".getMeterialSearchYear");
	}
	
	//자재관리 총건수
		public int getSystemMeterialCnt(CommandMap paramMap) throws Exception {
			return sqlSession.selectOne(NAMESPACE+".getSystemMeterialCnt", paramMap.getMap());
		}
		
	
	//자재관리 조회
		public List<Map<String, Object>> getSystemMeterialList(CommandMap paramMap) throws Exception {
			List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getSystemMeterialList", paramMap.getMap());
			return resultList;
		}		
	
	
	
	
	//자재관리 상세조회
	public HashMap<String, Object> getSystemMeterialDetail(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getSystemMeterialDetail", paramMap.getMap());
		return resultMap;
	}
	
	
	
	
	public int insertSystemMeterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".insertSystemMeterial", paramMap.getMap());
		
		return cnt;
	}
	
	public int updateSystemMeterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".updateSystemMeterial", paramMap.getMap());
		
		return cnt;
	}
	
	public int deleteSystemMeterial(CommandMap paramMap) throws Exception {
		int cnt = sqlSession.update(NAMESPACE+".deleteSystemMeterial", paramMap.getMap());
		
		return cnt;
	}
	
	
	
	
}
