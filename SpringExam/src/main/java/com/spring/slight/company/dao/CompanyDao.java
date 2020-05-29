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
	
	//보수내역입력 총건수
	public int getCompanyRepairCnt(CommandMap paramMap) throws Exception {
		return sqlSession.selectOne(NAMESPACE+".getCompanyRepairCnt", paramMap.getMap());
	}
	
	//보수내역입력 조회
	public List<Map<String, Object>> getCompanyRepairList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getCompanyRepairList", paramMap.getMap());
		return resultList;
	}
	
	//보수내역입력 상세조회
	public HashMap<String, Object> getCompanyRepairDetail(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getCompanyRepairDetail", paramMap.getMap());
		return resultMap;
	}
	
	
//	public List<Map<String, Object>> getDetRepirList(CommandMap paramMap) throws Exception {
//		List<Map<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getDetRepirList", paramMap.getMap());
//		
//		return resultMap;
//	}
	
	public List<Map<String, Object>> getMaterialList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getMaterialList", paramMap.getMap());
		return resultMap;
	}
	
	public List<Map<String, Object>> getMaterialUsedList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultMap = sqlSession.selectList(NAMESPACE+".getMaterialUsedList", paramMap.getMap());
		return resultMap;
	}
	
	public HashMap<String, Object> getMaterialUsedMap(CommandMap paramMap) throws Exception {
		HashMap<String, Object> resultMap = sqlSession.selectOne(NAMESPACE+".getMaterialUsedMap", paramMap.getMap());
		return resultMap;
	}
	
	public int updateCompanyRepair(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateCompanyRepair", paramMap.getMap());
	}
	
	public int updateCompanyRepairPart(CommandMap paramMap) throws Exception {
		return sqlSession.update(NAMESPACE+".updateCompanyRepairPart", paramMap.getMap());
	}
	
	public int insertMaterialUsed(CommandMap paramMap) throws Exception {
		return sqlSession.insert(NAMESPACE+".insertMaterialUsed", paramMap.getMap());
	}
	
	public int updateMaterialUsed(CommandMap paramMap) throws Exception {
		return sqlSession.insert(NAMESPACE+".updateMaterialUsed", paramMap.getMap());
	}
	
	public int deleteMaterialUsed(CommandMap paramMap) throws Exception {
		return sqlSession.insert(NAMESPACE+".deleteMaterialUsed", paramMap.getMap());
	}
	
	//보수내역입력 엑셀다운로드
	public List<Map<String, Object>> getCompanyRepairExcelList(CommandMap paramMap) throws Exception {
		List<Map<String, Object>> resultList = sqlSession.selectList(NAMESPACE+".getCompanyRepairExcelList", paramMap.getMap());
		return resultList;
	}
	
	
}
