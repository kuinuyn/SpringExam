package com.spring.common.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class FilesVO extends CommonVO{
	private String seq;
	private int file_no;
	private String file_name_key;
	private String file_name;
	private String file_path;
	private String file_size;
	private String remark;
	private String del_yn;
	
	//파일 업로드 시 추가
	private List<MultipartFile> files;
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public int getFile_no() {
		return file_no;
	}
	public void setFile_no(int file_no) {
		this.file_no = file_no;
	}
	public String getFile_name_key() {
		return file_name_key;
	}
	public void setFile_name_key(String file_name_key) {
		this.file_name_key = file_name_key;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getFile_path() {
		return file_path;
	}
	public void setFile_path(String file_path) {
		this.file_path = file_path;
	}
	public String getFile_size() {
		return file_size;
	}
	public void setFile_size(String file_size) {
		this.file_size = file_size;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public List<MultipartFile> getFiles() {
		return files;
	}
	public void setFiles(List<MultipartFile> files) {
		this.files = files;
	}
}
