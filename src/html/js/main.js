
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

function dataURItoBlob(dataURI) {
        // convert base64/URLEncoded data component to raw binary data held in a string
    var byteString;
    if (dataURI.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(dataURI.split(',')[1]);
    else
        byteString = unescape(dataURI.split(',')[1]);

    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }

    return new Blob([ia], {type:mimeString});
}

function blobToFile(theBlob, fileName){
    //A Blob() is almost a File() - it's just missing the two properties below which we will add
    theBlob.lastModifiedDate = new Date();
    theBlob.name = fileName;
    return theBlob;
}

function ISODateString(d) {
        function pad(n) {return n<10 ? '0'+n : n}
        return d.getUTCFullYear()+'-'
        + pad(d.getUTCMonth()+1)+'-'
        + pad(d.getUTCDate())+'T'
        + pad(d.getUTCHours())+':'
        + pad(d.getUTCMinutes())+':'
        + pad(d.getUTCSeconds())+'Z'
}


function getName (str){
        if (str.lastIndexOf('\\')){
            var i = str.lastIndexOf('\\')+1;
        }
        else{
            var i = str.lastIndexOf('/')+1;
        }                       
        var filename = str.slice(i);            
        var uploaded = document.getElementById("fileformlabel");
        uploaded.innerHTML = filename;
}