package com.spring.board.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.common.vo.CommonVO;
import com.spring.common.vo.FilesVO;

public class BoardVO extends CommonVO{
	private int board_seq;
	private int board_re_ref;
	private int board_re_lev;
	private int board_re_seq;
	private String board_writer;
	private String board_subject;
	private String board_content;
	private int board_hits;
	private String del_yn;
	private String search_type;
	private String result;
	
	//파일 업로드 시 추가
	private List<MultipartFile> files;
	private String board_file;
	private String delete_file;
	
	//파일 다운로드 시 추가
	private List<FilesVO> downloadFiles;
	
	public int getBoard_seq() {
		return board_seq;
	}
	public void setBoard_seq(int board_seq) {
		this.board_seq = board_seq;
	}
	public int getBoard_re_ref() {
		return board_re_ref;
	}
	public void setBoard_re_ref(int board_re_ref) {
		this.board_re_ref = board_re_ref;
	}
	public int getBoard_re_lev() {
		return board_re_lev;
	}
	public void setBoard_re_lev(int board_re_lev) {
		this.board_re_lev = board_re_lev;
	}
	public int getBoard_re_seq() {
		return board_re_seq;
	}
	public void setBoard_re_seq(int board_re_seq) {
		this.board_re_seq = board_re_seq;
	}
	public String getBoard_writer() {
		return board_writer;
	}
	public void setBoard_writer(String board_writer) {
		this.board_writer = board_writer;
	}
	public String getBoard_subject() {
		return board_subject;
	}
	public void setBoard_subject(String board_subject) {
		this.board_subject = board_subject;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public int getBoard_hits() {
		return board_hits;
	}
	public void setBoard_hits(int board_hits) {
		this.board_hits = board_hits;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public String getSearch_type() {
		return search_type;
	}
	public void setSearch_type(String search_type) {
		this.search_type = search_type;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	
	public List<MultipartFile> getFiles() {
		return files;
	}
	public void setFiles(List<MultipartFile> files) {
		this.files = files;
	}
	public String getBoard_file() {
		return board_file;
	}
	public void setBoard_file(String board_file) {
		this.board_file = board_file;
	}
	public List<FilesVO> getDownloadFiles() {
		return downloadFiles;
	}
	public void setDownloadFiles(List<FilesVO> downloadFiles) {
		this.downloadFiles = downloadFiles;
	}
	public String getDelete_file() {
		return delete_file;
	}
	public void setDelete_file(String delete_file) {
		this.delete_file = delete_file;
	}
	@Override
	public String toString() {
		return "BoardVO [board_seq=" + board_seq + ", board_re_ref=" + board_re_ref + ", board_re_lev=" + board_re_lev
				+ ", board_re_seq=" + board_re_seq + ", board_writer=" + board_writer + ", board_subject="
				+ board_subject + ", board_content=" + board_content + ", board_hits=" + board_hits + ", del_yn="
				+ del_yn + ", search_type=" + search_type + ", result=" + result + ", getLimit()="
				+ getLimit() + ", getOffset()=" + getOffset() + ", getPagination()=" + getPagination()
				+ ", getFunction_name()=" + getFunction_name() + ", getCurrent_page_no()=" + getCurrent_page_no()
				+ ", getCount_per_page()=" + getCount_per_page() + ", getCount_per_list()=" + getCount_per_list()
				+ ", getTotal_page_count()=" + getTotal_page_count() + ", getTotal_list_count()="
				+ getTotal_list_count() + "]";
	}
	
}
