package com.spring.common.util;

import com.spring.common.CommandMap;

public class PagingUtil {
	private final static int COUNT_PER_PAGE = 10;
	private final static int COUNT_PER_LIST = 10;
	
	public static CommandMap setPageUtil(CommandMap paramMap) {
		
		String pagination = ""; //페이징 결과 값
		String functionName = (String) paramMap.get("function_name"); // 페이징 목록을 요청하는 자바스크립트 함수명
		int currentPage = Integer.parseInt((String) paramMap.get("current_page_no")); // 현재 페이지 번호
		int countPerList = COUNT_PER_LIST; // 한 화면에 출력될 게시물 수
		int countPerPage = COUNT_PER_PAGE; // 한 화면에 출력될 페이지 수
		int totalListCount = (Integer) paramMap.get("total_list_count"); // 총 게시물 수
		int totalPageCount = totalListCount / countPerList; // 총 페이지 수
		if (totalListCount % countPerList > 0) { // 총 페이수를 구할 때 int형으로 계산하면 나머지가 있는 경우 게시물이 존재하기 때문에 총 페이지의 수를 수정
			totalPageCount = totalPageCount + 1;
		}
		
		int viewFirstPage = (((currentPage - 1) / countPerPage) * countPerPage) + 1; // 한 화면에 첫 페이지 번호
		int ViewLastPage = viewFirstPage + countPerPage - 1; // 한 화면에 마지막 페이지 번호
		if (ViewLastPage > totalPageCount) { // 마지막 페이지의 수가 총 페이지의 수보다 큰 경우는 게시물이 존재하지 않기 때문에 마지막 페이지의 수를 수정
			ViewLastPage = totalPageCount;
		}
		
		int totalFirstPage = 1; // 전체 페이지 중에 처음 페이지
		int totalLastPage = totalPageCount; // 전체 페이지 중에 마지막 페이지
		int prePerPage = 0; // 이전 화면에 첫번째 번호
		if (viewFirstPage - countPerPage > 0) {
			prePerPage = viewFirstPage - countPerPage;
		} else {
			prePerPage = totalFirstPage;
		}
		int nextPerPage = 0; // 이후 화면에 첫번째 번호
		if (viewFirstPage + countPerPage < totalPageCount) {
			nextPerPage = viewFirstPage + countPerPage;
		} else {
			nextPerPage = totalPageCount;
		}
		
		// 페이지 네이게이션 설정
		pagination += "<div class='list_paging'>";
//		pagination += "<a href='javascript:" + functionName + "(\"" + totalFirstPage + "\");' class=\"parrow\">[<<]</a>";
		pagination += "<a href='javascript:" + functionName + "(" + prePerPage + ");' class=\"parrow\"><span class=\"arrow_left\"></span></a>";
		for (int a = viewFirstPage; a <= ViewLastPage; a++) {
			if (a == currentPage) {
//				pagination += "<a href='javascript:" + functionName + "(\"" + a + "\");' class='onpage'>[" + a + "]</a>";
				pagination += "<strong class='cur_num'>" + a + "</strong>";
			} else {
				pagination += "<a href='javascript:" + functionName + "(\"" + a + "\");' class='num_box'>" + a + "</a>";
			}
		}
		pagination += "<a href='javascript:" + functionName + "(" + nextPerPage + ");' class=\"parrow\"><span class=\"arrow_right\"></span></a>";
//		pagination += "<a href='javascript:" + functionName + "(" + totalLastPage + ");' class=\"direction_right01\">[>>]</a>";
		pagination += "</div>";

		int offset = ((currentPage - 1) * countPerPage) + 0; // 한 화면의 표출되는 게시물의 시작 번호의 -1 (쿼리 조건절)
		
		// LIMIT는 가져올 row의 수, OFFSET은 몇 번째 row부터 가져올지를 결정
		paramMap.put("limit", countPerList);
		paramMap.put("offset", offset);
		paramMap.put("pagination", pagination);
		
		return paramMap;
	}
}
