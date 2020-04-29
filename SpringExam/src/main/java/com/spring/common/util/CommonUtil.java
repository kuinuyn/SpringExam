package com.spring.common.util;

/**
 * 여러 개의 결과 값을 리턴하기 위한 클래스 (성공 유무, 메세지, 조회 내용 등)
 */
public class CommonUtil {
	// 입력받은 스트링을 EUC-KR로 변환해서 돌려줌.
		public String toEucKr(String s) {
			try {
				return new String(s.getBytes("iso-8859-1"), "EUC-KR");
			} catch (Exception e) {
				return s;
			}
		}

		// 입력받은 스트링을 ISO-8859-1로 변환해서 돌려줌
		public String to8859(String s) {
			try {
				return new String(s.getBytes("EUC-KR"), "iso-8859-1");
			} catch (Exception e) {
				return s;
			}
		}

		// 입력받은 스트링을 EUC-KR로 변환해서 돌려줌.
		public String iso8859toEucKr(String s) {
			try {
				return new String(s.getBytes("8859_1"), "utf-8");
			} catch (Exception e) {
				return s;
			}
		}

		// 입력받은 스트링이 null 이거나 빈값이라면 두번째입력받은 스트링으로 반환한다., 그렇지 않을경우 trim()한 값을 돌려줌.
		public String toParamStr(String oldStr, String newStr) {
			try {
				if (oldStr == null || oldStr.equals("")) {
					return newStr;
				} else {
					return oldStr.trim();
				}
			} catch (Exception e) {
				return oldStr;
			}
		}

		// 입력받은 스트링이 null이면 빈값(""), 그렇지 않을경우 trim()한 값을 돌려줌.
		public String toNullStr(String s) {
			try {
				if (s == null) {
					return "";
				} else {
					return s.trim();
				}
			} catch (Exception e) {
				return s;
			}
		}

		// 입력받은 스트링이 null이면 &nbsp;를 돌려줌.
		public String toNbsp(String s) {
			try {
				if (s == null || s.equals("")) {
					return "&nbsp;";
				} else {
					if (s.trim().length() > 1) {
						return s;
					}
					return "&nbsp;";
				}
			} catch (Exception e) {
				return s;
			}
		}
		
		// 입력받은 숫자가 null이면 &nbsp;를 돌려줌.
		public String toNbsp(int i) {
			try {
				if (Integer.toString(i).equals("")) {
					return "&nbsp;";
				} else {
					return Integer.toString(i);
				}
			} catch (Exception e) {
				return Integer.toString(i);
			}
		}

		// 입력받은 스트링을 숫자만큼 자르고 뒤에 지정한 문자를 붙여줌.
		public String substring(String str, int len, String tail) {
			String rtn = null;
			try {
				if (str == null) return rtn;
				if (str.length() > len) {
					rtn = str.substring(0, len) + tail;
				} else {
					rtn = str;
				}
			} catch (Exception e) {
				return str;
			}
			return rtn;
		}

		// 숫자 앞에 '0'붙히기
		// str : 원래문자, addstr : 붙히고자 하는 문자, num : 만들고자 하는 length
		public String addStr(String str, String addstr, int num) {
			try {
				if ( str != null && addstr != null && num != 0 ) {
					String temp = "";
					for (int i = 0; i < num-str.length(); i++)
					{
						temp = temp + addstr;
					}
					str = temp + str;
				}
			} catch (Exception e) {
				System.out.println("[gumi] addStr(String str, String addstr, int num) Err : " + e.toString());	
			}
			return str;
		}
	
}
