//모달 팝업1
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

//모달 팝업2
function modal_popup2(el){

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수

    if(bg){
            $('.modal-popup2').fadeIn();   //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
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
            $('.modal-popup2').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        }else{
            temp.fadeOut();
        }
        
        $(this).scrollTop(0);
        e.preventDefault();
    });

    $('.modal-popup2 .bg').click(function(e){  //배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
        $('.modal-popup2').fadeOut();
        $(this).scrollTop(0);
        e.preventDefault();
    });

};

//모달 팝업3
function modal_popup3(el){

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수

    if(bg){
            $('.modal-popup3').fadeIn();   //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
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
            $('.modal-popup3').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        }else{
            temp.fadeOut();
        }
        e.preventDefault();
    });

    $('.modal-popup3 .bg').click(function(e){  //배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
        $('.modal-popup3').fadeOut();
        e.preventDefault();
    });

};

//모달 팝업4
function modal_popup4(el){

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수

    if(bg){
            $('.modal-popup4').fadeIn();   //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
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
            $('.modal-popup4').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        }else{
            temp.fadeOut();
        }
        e.preventDefault();
    });

    $('.modal-popup4 .bg').click(function(e){  //배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
        $('.modal-popup4').fadeOut();
        e.preventDefault();
    });

};

//모달 팝업5
function modal_popup5(el){

    var temp = $('#' + el);
    var bg = temp.prev().hasClass('bg');    //dimmed 레이어를 감지하기 위한 boolean 변수

    if(bg){
            $('.modal-popup5').fadeIn();   //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
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
            $('.modal-popup5').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
        }else{
            temp.fadeOut();
        }
        e.preventDefault();
    });

    $('.modal-popup5 .bg').click(function(e){  //배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
        $('.modal-popup5').fadeOut();
        e.preventDefault();
    });

};


