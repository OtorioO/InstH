$(document).ready(function(){



    //mobile menu toggling
    $("#menu_icon").click(function(){
        $("header nav ul").toggleClass("show_menu");
        $("#menu_icon").toggleClass("close_menu");
        return false;
    });

    

    //Contact Page Map Centering
    var hw = $('header').width() + 50;
    var mw = $('#map').width();
    var wh = $(window).height();
    var ww = $(window).width();

    $('#map').css({
        "max-width" : mw,
        "height" : wh
    });

    if(ww>1100){
         $('#map').css({
            "margin-left" : hw
        });
    }

   



    //Tooltip
    $("a").mouseover(function(){

        var attr_title = $(this).attr("data-title");

        if( attr_title == undefined || attr_title == "") return false;
        
        $(this).after('<span class="tooltip"></span>');

        var tooltip = $(".tooltip");
        tooltip.append($(this).data('title'));

         
        var tipwidth = tooltip.outerWidth();
        var a_width = $(this).width();
        var a_hegiht = $(this).height() + 3 + 4;

        //if the tooltip width is smaller than the a/link/parent width
        if(tipwidth < a_width){
            tipwidth = a_width;
            $('.tooltip').outerWidth(tipwidth);
        }

        var tipwidth = '-' + (tipwidth - a_width)/2;
        $('.tooltip').css({
            'left' : tipwidth + 'px',
            'bottom' : a_hegiht + 'px'
        }).stop().animate({
            opacity : 1
        }, 200);
       

    });

    $("a").mouseout(function(){
        var tooltip = $(".tooltip");       
        tooltip.remove();
    });


});







function readCookie(name) {
    // Найдем конкретный куки и вернем его значение
    var searchName = name + "=";
    var cookies = document.cookie.split(';');
    for(var i = 0; i < cookies.length; i++) {
        var c = cookies[i];
        while (c.charAt(0) == ' ')
            c = c.substring(1, c.length);
        if(c.indexOf(searchName) == 0)
            return c.substring(searchName.length, c.length);        
    }
    return null;
}