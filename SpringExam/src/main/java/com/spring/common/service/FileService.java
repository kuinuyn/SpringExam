package com.spring.common.service;

import java.util.List;

import com.spring.common.vo.FilesVO;

public interface FileService {
	public FilesVO getFiles(FilesVO vo) throws Exception;
	public List<FilesVO> getFilesList(FilesVO vo) throws Exception;
}
