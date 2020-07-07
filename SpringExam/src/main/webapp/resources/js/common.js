function drawCodeData(list, gubun, tagNm, mode, code) {
	var listCnt = list.length;
	var resStr = "";
	var curCnt = 1;
	
	if(listCnt <= 0) {
		return new Promise(function(resolve, reject) {
			resolve(resStr);
		});
	}
	
	if(tagNm == "select") {
		if(code == "00" || code == "" || code == null) {
			resStr += "<option value='' selected >"+(mode=="ALL"?"전체":"선택")+"</option>";
		}
		else {
			resStr += "<option value=''>"+(mode=="ALL"?"전체":"선택")+"</option>";
		}
		
		for(i=0; i < listCnt; i++) {
			if(list[i].code_type == gubun) {
				if(list[i].data_code == code) {
					resStr += "<option value='"+list[i].data_code+"' selected >"+list[i].data_code_name+"</option>";
				}
				else {
					resStr += "<option value='"+list[i].data_code+"'>"+list[i].data_code_name+"</option>";
				}
			}
		}
		
	}
	else {
		resStr = "<tr>";
		for(i=0; i < listCnt; i++) {
			if(list[i].code_type == gubun) {
				curCnt++;
				
				if(curCnt == 2) {
					if(code == "00" || code == "" || code == null) {
						resStr += "<td>";
						resStr += "<a href="+"javascript:searchArea('')"+"><span class='black03'>전체</span></a>";
						resStr += "</td>";
					}
					else {
						resStr += "<td>";
						resStr += "<a href="+"javascript:searchArea('')"+"><span>전체</span></a>";
						resStr += "</td>";
					}
				}
				
				if(list[i].data_code == code) {
					resStr += "<td>";
					resStr += "<a href="+"javascript:searchArea(\""+list[i].data_code+"\")"+"><span class='black03'>"+list[i].data_code_name+"</span></a>";
					resStr += "</td>";
				}
				else {
					resStr += "<td>";
					resStr += "<a href="+"javascript:searchArea(\""+list[i].data_code+"\")"+"><span>"+list[i].data_code_name+"</span></a>";
					resStr += "</td>";
				}
				
				if(curCnt % 4 == 0) {
					resStr += "</tr><tr>";
				}
				else if(curCnt == listCnt) {
					resStr += "</tr>";
				}
			}
			
		}
	}
	
	return new Promise(function(resolve, reject) {
		resolve(resStr);
	});
}

function popupSubmin(url, param, form) {
	
}

//Minny
//2002.11.14
	
	function isLetter(ch, letter){
		for (k=0; k < letter.length; k++){
			if (ch == letter.charAt(k)) return true;
		}
		return false;
	}	
	
	function trim(str){
		str = rtrim(str);
		str = ltrim(str);	
		return str;
	}	
	
	function ltrim(str){
		len = str.length;
		for (i=0; i < len; i++){		
			if (str.charAt(0) == " "){
				str = str.substring(1);
			} else {			
				break;
			}
		}
		return str;
	}
	
	function numbersonly(e, decimal) {
		var key;
		var keychar;

		if (window.event) {
			key = window.event.keyCode;
		} else if (e) {
			key = e.which;
		} else {
			return true;
		}

		keychar = String.fromCharCode(key);

		if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) {
			return true;
		} else if ((("0123456789").indexOf(keychar) > -1)) {
			return true;
		} else if (decimal && (keychar == ".")) {
			return true;
		} else {
			return false;
		}
	}

	function toTrim(val){
		return val?val.replace(/(^\s*)|(\s*$)/g, ""):val;
	}

	function rtrim(str){
		len = str.length;
		for (i=0; i < len; i++){		
			if (str.charAt(str.length-1) == " "){
				str = str.substring(0, str.length-1);
			} else {
				break;
			}
		}
		return str;
	}
	
	function isAlphaNumeric(str){	
		letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890	'`~!@#$%^&*()-_=+.,?\/:; ";
		letter = letter + '"';
		letter = letter + String.fromCharCode(13);
		letter = letter + String.fromCharCode(10);
		for(i=0; i < str.length; i++) {			
			if(!isLetter(str.charAt(i), letter))return false;
		}
		return true;
	}	//알파벳과 숫자 그리고 특수문자 체크
	
	function hasNoSpace(str){
		for(l=0; l < str.length; l++) {
			if(str.charAt(l) == " ")return false;
		}
		return true;
	}		//빈칸 체크
	
/*
	function checkEmail(sEmail){
		if (trim(sEmail) == "") return true;
		str = sEmail.split('@');	
		if (str.length != 2)return false;
		if (!isAlphaNumeric(str[0])) return false;
		str = str[1].split('.');
		if (str.length < 2) return false;
		for(m=0; m < str.length; m++){
			if(str[m].length < 1) return false;
			if (!isAlphaNumeric(str[m])) return false;
		}
		return true;
	}	//E_mail 체크
*/
	function token(chkstr){
		var Status = 0;
		var num=0;
		var i;
		var ctype = "";
		
		i = 0;
		while (i < chkstr.length) {
			num = chkstr.charAt(i);
			if (Status == 0) {
				if (isDigit(num)) {
					Status = 1;
					i++;  
				} else {
					Status = 10;
					break;
				}
			} else if (Status == 1) {
				if (isDigit(num)) {
					Status = 1;
					i++;
				} else if (num == ".") {
					Status = 2;
					i++;
				} else {
					Status = 10;
					break;
				}
			} else if (Status == 2) {
				if (isDigit(num)) {
					i++;
				} else {
					Status = 10;
					break;
				}
			}
		}
		if (Status == 1) 		ctype = "integer";
		else if (Status == 2)	ctype = "float";
		else if (Status == 10)	ctype = "invalid";
  	
		return ctype;
	}

	function isDigit(num){
	   return (num >= "0" && num <= "9") ? true : false; 
	}
	function isNumber(chkStr) {
		if (chkStr.length == 0) return true;
		var result = token(chkStr);
		return (result == "invalid" || result == "float") ? false : true;	
	}
	//날짜검색
function isDate(str) {
	sInputDate = str.split('-');
	
	if (sInputDate.length != 3) {sInputDate = str.split('.');}
	if (sInputDate.length != 3) {sInputDate = str.split('/');}
	if (sInputDate.length != 3) return false;
			
	if (!isNumber(sInputDate[0]) || !isNumber(sInputDate[1]) || !isNumber(sInputDate[2])) return false;
	
	if (sInputDate[0] > 9999 || sInputDate[0] < 0) return false;
	if (sInputDate[1] > 12 || sInputDate[1] < 0) return false;
	
	var aDaysInMonth=new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	
	if ( (sInputDate[1] == 2) && (sInputDate[0]%4==0 && sInputDate[0]%100!=0 || sInputDate[0] % 400==0) ) {
		aDaysInMonth[1] = 29;
	}
	
	iDaysInMonth = aDaysInMonth[eval(sInputDate[1]) -1];		
	
	if (sInputDate[2] > 0 && sInputDate[2] <= iDaysInMonth) return true;
	else return false;

}
	// E-mail Address Check (Use : regular expressions)
	function checkEmail(strEmail)
	{ 
		var exclude=/[^@\-\.\w]|^[_@\.\-]|[\._\-]{2}|[@\.]{2}|(@)[^@]*\1/;
		var check=/@[\w\-]+\./;
		var checkend=/\.[a-zA-Z]{2,3}$/;
		
	        if(((strEmail.search(exclude) != -1)||(strEmail.search(check)) == -1)||(strEmail.search(checkend) == -1)){
	                return false;
	        }
	        else {
	                return true;
	        }
/*
		var filter=/^(\w+(?:\.\w+)*)@((?:\w+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
	
		if (filter.test(strEmail))
		{
			return true;
		}
		else
		{ 
			return false;
		}
*/
	} 

	// TelePhone, Fax. Check
	function checkTel(strTel1, strTel2, strTel3)
	{
		if ( !Number(strTel1) || !Number(strTel2) || !Number(strTel3) )
		{
			return false;	
		}
		else
		{
			if ( strTel1.length!=2 && strTel1.length!=3 )
			{
				return false;
			}	
			else
			{
				if ( strTel2.length!=3 && strTel2.length!=4 )
				{
					return false;
				}	
				else
				{
					if ( strTel3.length!=4 )
					{
						return false;
					}
					else
					{
						return true;
					}
				}
			}	
		}
	}

	// CellularPhone Check
	function checkMobile(strM1, strM2, strM3)
	{
		if ( !Number(strM1) || !Number(strM2) || !Number(strM3) )
		{
			alert('1');
			return false;
		}
		else
		{
			if ( strM1.length!=3 )
			{
							alert('2');
				return false;
			}	
			else
			{
				if ( strM2.length!=3 && strM2.length!=4 )
				{
								alert('3');
					return false;
				}	
				else
				{
					if ( strM3.length!=4 )
					{
									alert('4');
						return false;
					}
					else
					{
						return true;
					}
				}
			}	
		}
	}
	
	// 사업자등록번호 체크
	function checkRegNo(strRegNo)
	{
		if ( !Number(strRegNo) || strRegNo.length!=10 )	
		{
			return false;
			
		}
		else
		{
			return true;
		}
	}

	//주민등록번호 check
	function checkJumin (strJumin1, strJumin2) {
		var tmp = 0

		var yy	= strJumin1.substring(0,2)
		var mm	= strJumin1.substring(2,4)
		var dd	= strJumin1.substring(4,6)
		var sex	= strJumin2.substring(0,1)
  	    
		if ((strJumin1.length != 6 ) || ( mm < 1 || mm > 12 || dd < 1) ) {
  		return false;
		}
  		
		if ((sex != 1 && sex !=2 && sex !=3 && sex !=4)|| (strJumin2.length != 7 )) {
 			return false;
		}
 		
		for (var i = 0; i <=5 ; i++)
			tmp = tmp + ((i%8+2) * parseInt (strJumin1.substring(i,i+1)))
 		
		for (var i = 6; i <=11 ; i++)
 			tmp = tmp + ((i%8+2) * parseInt (strJumin2.substring(i-6,i-5)))
 		
		tmp = 11 - (tmp % 11)
		tmp = tmp % 10
 		
		if (tmp != strJumin2.substring(6,7)) {
 			return false;
		}  
		return true;
	}

	// 사업자등록번호 체크
	function checkCompanyCode(strCompanyCode)
	{
		if ( !Number(strCompanyCode) || strCompanyCode.length!=4 )	
		{
			return false;
			
		}
		else
		{
			return true;
		}
	}

	// Zip Code Popup
  function popZipCode(strURL)
  {
      AnotherWin = window.open(strURL,"popZipCode",
      "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=420c,height=500");
  }

	function getWindowHeight() {
		if (window.self && self.innerHeight) {
			return self.innerHeight;
		}
		if (document.documentElement && document.documentElement.clientHeight) {
			return document.documentElement.clientHeight;
		}
		else if (document.body) {
			return document.body.clientHeight;
		} 
		return 0;
	}

	function getWindowWidth() {
		if (window.self && self.innerWidth) {
			return self.innerWidth;
		}
		if (document.documentElement && document.documentElement.clientWidth) {
			return document.documentElement.clientWidth;
		}
		else if (document.body) {
			return document.body.clientWidth;
		} 
		return 0;
	}
	
	function chkContactNumber(str) {
		var chk = true;
		
		if(str.length < 10 || str.length > 11) {
			chk = false;
		}
		
		return chk;
	}
	
	function formatContactNumber(str) {
		if(str.length > 0) {
			if(str.length < 10 && str.length > 11) {
				alert("연락처가 정확하지 않습니다.");
				
				return;
			}
			else {
				if(str.length == 10) {
					str = str.substring(0, 3)+"-"+str.substring(3, 6)+"-"+str.substring(7, 10);
				}
				else if(str.length == 11) {
					str = str.substring(0, 3)+"-"+str.substring(3, 7)+"-"+str.substring(7, 11);
				}
			}
		}
		
		return str;
	}

	function loginProcess() {
		var chk = true;
		
		if($("#user_id").val() == "" || $("#user_id").val() == null) {
			alert("아이디를 입력하세요.");
			$("#user_id").focus();
			chk = false;
		}
		
		if(chk) {
			if($("#pw").val() == "" || $("#pw").val() == null) {
				alert("비밀번호를 입력하세요.");
				$("#pw").focus();
				chk = false;
			}
		}
		
		if(chk) {
			document.loginForm.submit();
		}
	}
	
	/**
	 * Sort Function
	 **/
	//default
	var config = {
		targetTable: "table.sortable",
		cssAsc: "order-asc",
		cssDesc: "order-desc",
		cssBg: "sortable",
		selectorHeaders: "thead th"
	};
	
	function sortEvent(elem) {

		var table = getTableElement(elem);
		if (!table) {
			return;
		}
		
		var sortOrder = !elem.classList.contains(config.cssAsc) ? 1 : -1;
		
		removeTHClass(table);
		setTHClass(elem, sortOrder, function() {
			Search(1, $(elem).find(".tt :first-child").text(), sortOrder);
		});
	}
	
	function getTableElement(elem) {
		var closest = function(th) {
			var parent = th.parentNode;
			if (parent.tagName.toUpperCase() === "TABLE") {
				return parent;
			}
			return closest(parent);
		};
		return closest(elem);
	}
	
	function removeTHClass(table) {
		var tableElem = table.querySelectorAll(config.selectorHeaders);
		Object.keys(tableElem).forEach(function(key) {
			tableElem[key].classList.remove(config.cssDesc);
			tableElem[key].classList.remove(config.cssAsc);
		});
	}
		
	function setTHClass(elem, sortOrder, callback) {
		if (sortOrder == 1) {
			elem.classList.add(config.cssAsc);
		}else {
			elem.classList.add(config.cssDesc);
		}
		
		callback();
	}