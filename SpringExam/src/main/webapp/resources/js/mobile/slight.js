
$(document).ready(function(){
	
	//메인공지롤링
	var height =  $(".notice").height(); 
	var num = $(".rolling li").length;
	var max = height * num;
	var move = 0;
	function noticeRolling(){
		move += height;
		$(".rolling").animate({"top":-move},600,function(){ 
			if( move >= max ){ 
				$(this).css("top",0); 
				move = 0; 
			};
		});
	};
	var noticeRollingOff = setInterval(noticeRolling,2000);
	$(".rolling").append($(".rolling li").first().clone()); 


	//서브메뉴슬라이드
	$('#sidebar').simpleSidebar({
    	opener: '#toggle-sidebar',
      	animation: { easing: 'easeOutQuint'}, sidebar: {align: 'right', closingLinks: '.close-sb'}, sbWrapper: { display: true }
    }); 

	//서브메뉴슬라이드2
	$('#sidebar').simpleSidebar({
    	opener: '#toggle-sidebar_m',
      	animation: { easing: 'easeOutQuint'}, sidebar: {align: 'right', closingLinks: '.close-sb'}, sbWrapper: { display: true }
    }); 

	// 공지사항 리스트
	$(function(){
	    $("#notice li h3").click(function(){
	        $("#notice li div").slideUp();
	        $('.ico_ar').css('background','');
	        if(!$(this).next().is(":visible"))
	        {
	            $(this).next().slideDown();
	            $(this).find('.ico_ar:eq(0)').css('background','url(../../html/img/list_up.png) no-repeat center');
	        }
	    });
	});

	// 슬라이드탭 터치
    var swiper_1 = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        slidesPerView: 5,
        paginationClickable: true,
        spaceBetween: 0,
        freeMode: true,
		pagination: false
    });

	$('.tabs > li > a').on('click', function(e){
		$(this).parent().addClass('active').siblings().removeClass('active');
		var tabIdx = $(this).parent().index();
		swiper_2.slideTo(tabIdx+1, 300);
		e.preventDefault();
	});

	var tabLen = $('.tabs > li').length;

	var swiper_2 = new Swiper('.swiper-container-2', {
		autoHeight: true,
        slidesPerView: 1,
        spaceBetween: 0,
		pagination: false,
		loop: true,
		onInit: function(swiper){
			
		},
		onSlideChangeStart: function(swiper){
			var idx = swiper.activeIndex-1;
			if( idx < 0 ) { 
				idx = tabLen - 1;
			} else if( idx == tabLen ){
				idx = 0;
			}
			$('.tabs > li').removeClass('active').eq(idx).addClass('active');
			if( idx < tabLen ) {
				swiper_1.slideTo(idx-1, 300);
			}
		}
    });

    //전화
    function callNumber(num){
	location.href="tel:"+num;
	};


});

//공통 모달 팝업
function modal_popup(el){

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수

    if(bg){
            $('.modal-popup').fadeIn();   //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
    }else{
            temp.fadeIn();
    }

    // 화면의 중앙에 레이어를 띄운다.
    if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
    else temp.css('top', '0px');
    if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
    else temp.css('left', '0px');

    // 팝업창닫기
    temp.find('a.cbtn').click(function(e){
        if(bg){
            $('.modal-popup').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        }else{
            temp.fadeOut();
        }
        e.preventDefault();
    });

    $('.modal-popup .bg').click(function(e){  //배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
        $('.modal-popup').fadeOut();
        e.preventDefault();
    });

};

