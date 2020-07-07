package com.spring.slight.info.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.common.CommandMap;

@Repository
public class InfoDao {
private static final String NAMESPACE = "com.spring.mapper.slight.info.infoMapper";
	
	@Resource(name="sqlSessionGumi")
	private SqlSession sqlSession;
	
	//자재관리 총건수
			public int getInfoNoticeListCnt(CommandMap paramMap) throws Exception {
				return sqlSession.selectOne(NAMESPACE+".getInfoNoticeListCnt", paramMap.getMap());
			}
	
	//자재관리 조회
			public List<Map<String, Object>> getInfoNoticeList(CommandMap paramMap) throws Exception {
				List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getInfoNoticeList", paramMap.getMap());
				return resultList;
			}		
		
		
		
		
		//자재관리 상세조회
		public HashMap<String, Object> getInfoNoticeDetail(CommandMap paramMap) throws Exception {
			HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getInfoNoticeDetail", paramMap.getMap());
			return resultMap;
		}
		
		
		
		
		public int insertInfoNotice(CommandMap paramMap) throws Exception {
			int cnt = sqlSession.update(NAMESPACE+".insertInfoNotice", paramMap.getMap());
			
			return cnt;
		}
		
		public int updateInfoNotice(CommandMap paramMap) throws Exception {
			int cnt = sqlSession.update(NAMESPACE+".updateInfoNotice", paramMap.getMap());
			
			return cnt;
		}
		
		public int deleteInfoNotice(CommandMap paramMap) throws Exception {
			int cnt = sqlSession.update(NAMESPACE+".deleteInfoNotice", paramMap.getMap());
			
			return cnt;
		}
	
}
