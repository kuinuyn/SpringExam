package com.spring.common.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.common.dao.FileDao;
import com.spring.common.vo.FilesVO;

@Service("FileService")
public class FileServiceImpl implements FileService{

	@Autowired
	private FileDao fileDao;

	@Override
	public FilesVO getFiles(FilesVO vo) throws Exception {
		return fileDao.getFiles(vo);
	}
	
}
