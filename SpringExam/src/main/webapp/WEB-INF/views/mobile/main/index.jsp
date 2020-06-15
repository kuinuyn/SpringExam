<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>도로조명정보시스템</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />

<!-- font-awesome -->
<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
<!-- css -->
<link rel="stylesheet" type="text/css" href="/resources/css/mobile/reset.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/mobile/contents.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/mobile/flexslider.css" />
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
<script src='/resources/js/mobile/jquery.simple-sidebar.min.js'></script>

<!-- js -->
<script src="/resources/js/mobile/slight.js"></script>
<script src="/resources/js/mobile/swiper.min.js"></script>
</head>

<body class="main">
<div id="mainWrap">

<!-- header -->
<header class="navbar navbar-fixed-top" id="navbar_m">
    <div class="navbar-content">
    	<h1 >도로조명정보시스템<a href="#" class="logo"></a></h1>
        <div id="toggle-sidebar_m"><a href="#" class="btn_navi"></a></div>
    </div>
</header>
<!-- //header -->
<hr>
<!-- navbar -->
<nav class="sidebar sidebar-right" id="sidebar">
    
	<h2 class="hide"> 메뉴</h2>
    <ul>
        <li class="close-sb n1"><a href="index.html"><i class="fa fa-home"></i>HOME</a></li>
        <li class="close-sb n1"><a href="map.html"><i class="fa fa-bullhorn"></i>고장신고</a></li>
		<li class="close-sb n1"><a href="list.html"><i class="fa fa-check-circle"></i>진행결과</a></li>
		<li class="close-sb n1"><a href="notice.html"><i class="fa fa-bars"></i>공지사항</a></li>
		<li class="close-sb n1"><a href="guide.html"><i class="fa fa-exclamation-circle"></i>사용안내</a></li>
		<li class="close-sb n1"><a href="login.html" class="btn_login"><span>관리자 로그인</span></a></li>
    </ul>

</nav>
<!-- //navbar -->
<hr>

	<section>
		<!-- 메인슬라이드배너 -->
		<h2 class="hide">메인배너</h2>
			<div id="container" class="cf">
				<div id="main" role="main">
				  <section class="slider">
					<div class="flexslider">
					  <ul class="slides">
							<li>이제 도로조명 고장신고를<BR> 간편하게 이용해보세요!</li>
							<li>가로등/보안등 관리를<BR> 편리하게 사용해보세요!</li>
						</ul>
					</div>
				  </section>
				</div>
			</div>

			  <!-- jQuery -->
			 <script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.min.js">\x3C/script>')</script>

			  <!-- FlexSlider -->
			  <script defer src="/resources/js/mobile/jquery.flexslider.js"></script>

			  <script type="text/javascript">
				/* $(function(){
				  SyntaxHighlighter.all();
				}); */
				$(window).load(function(){
				  $('.flexslider').flexslider({
					animation: "slide",
					start: function(slider){
					  $('body').removeClass('loading');
					}
				  });
				});
			  </script>
		
		
		<!-- //메인슬라이드배너 -->

		<h2 class="hide">메뉴</h2>
		<ul class="menu">
			<li>
				<a href="map.html">
					<div id="menu01">
						<p><span class="white01">가로등/보안등이 문제가 생겼나요?</span></p>
						<p><span class="black01">고장신고</span></p>
						<span href="#" class="micon01"></span>
					</div>
				</a>
			</li>
		</ul>
		<ul class="submenu">
			<li>
				<a href="list.html">
					<div id="menu02">
						<p><span class="black02">진행결과</span></p>
						<p><span class="red01">GO</span></p>
						<span href="#" class="micon02"></span>
					</div>
				</a>
			</li>
			<li>
				<a href="notice.html">
					<div id="menu02">
						<p><span class="black02">공지사항</span></p>
						<p><span class="red01">GO</span></p>
						<span href="#" class="micon03"></span>
					</div>
				</a>
			</li>
	</ul>
		
		<h3 class="hide"></h3>
		<ul class="menubtm">
			<li>
				<a href="#"></a>
				<span class="black03">신고건수</span>
				<span class="sky01 pdl5">2752건</span>
				<span class="black03 pdl15">지난주</span>
				<span class="sky01 pdl5">25건</span>
				<span class="black03 pdl15">지난달</span>
				<span class="sky01 pdl5">157건</span>
			</li>
			
		</ul>

		<h3 class="hide">사용안내</h3>
		<ul class="guide">
			<li>
				<a href="guide.html">
					<div id="guide01">
						<p><span class="white02">모바일 사용이 처음이신가요?</span></p>
						<p><span class="white03">도로조명 사용가이드 TIP</span></p>
						<span href="#" class="gicon"></span>
					</div>
				</a>
			</li>
		</ul>
	</section>
	<hr/>

	<footer>
		<h4>공지</h4>
		<div class="notice">
			<ul class="rolling">
				<li><a href="#">새로워진 도로조명정보시스템을 소개합니다.</a></li>
			</ul>
		</div> 
	</footer>
	
<!--loding-->
<div id="loading-wrap" class="hide"><div id="loading"></div></div>
<!--//loding-->   
		
</body>
</html>
