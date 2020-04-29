package com.spring.common.vo;

import java.util.Date;

public class CommonVO {
	private int limit;
	private int offset;
	private String pagination;
	private String function_name;
	private int current_page_no;
	private int count_per_page;
	private int count_per_list;
	private int total_page_count;
	private int total_list_count;
	private String ins_user_id;
	private Date ins_date;
	private String upd_user_id;
	private Date upd_date;
	
	public int getLimit() {
		return limit;
	}
	
	public void setLimit(int limit) {
		this.limit = limit;
	}
	
	public int getOffset() {
		return offset;
	}
	
	public void setOffset(int offset) {
		this.offset = offset;
	}
	
	public String getPagination() {
		return pagination;
	}
	
	public void setPagination(String pagination) {
		this.pagination = pagination;
	}

	public String getFunction_name() {
		return function_name;
	}

	public void setFunction_name(String function_name) {
		this.function_name = function_name;
	}

	public int getCurrent_page_no() {
		return current_page_no;
	}

	public void setCurrent_page_no(int current_page_no) {
		this.current_page_no = current_page_no;
	}

	public int getCount_per_page() {
		return count_per_page;
	}

	public void setCount_per_page(int count_per_page) {
		this.count_per_page = count_per_page;
	}

	public int getCount_per_list() {
		return count_per_list;
	}

	public void setCount_per_list(int count_per_list) {
		this.count_per_list = count_per_list;
	}

	public int getTotal_page_count() {
		return total_page_count;
	}

	public void setTotal_page_count(int total_page_count) {
		this.total_page_count = total_page_count;
	}

	public int getTotal_list_count() {
		return total_list_count;
	}

	public void setTotal_list_count(int total_list_count) {
		this.total_list_count = total_list_count;
	}
	public String getIns_user_id() {
		return ins_user_id;
	}
	public void setIns_user_id(String ins_user_id) {
		this.ins_user_id = ins_user_id;
	}
	public Date getIns_date() {
		return ins_date;
	}
	public void setIns_date(Date ins_date) {
		this.ins_date = ins_date;
	}
	public String getUpd_user_id() {
		return upd_user_id;
	}
	public void setUpd_user_id(String upd_user_id) {
		this.upd_user_id = upd_user_id;
	}
	public Date getUpd_date() {
		return upd_date;
	}
	public void setUpd_date(Date upd_date) {
		this.upd_date = upd_date;
	}
}
