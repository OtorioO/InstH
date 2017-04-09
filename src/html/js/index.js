$('.form').find('input, textarea').on('keyup blur focus', function (e) {
  
  var $this = $(this),
      label = $this.prev('label');

	  if (e.type === 'keyup') {
			if ($this.val() === '') {
          label.removeClass('active highlight');
        } else {
          label.addClass('active highlight');
        }
    } else if (e.type === 'blur') {
    	if( $this.val() === '' ) {
    		label.removeClass('active highlight'); 
			} else {
		    label.removeClass('highlight');   
			}   
    } else if (e.type === 'focus') {
      
      if( $this.val() === '' ) {
    		label.removeClass('highlight'); 
			} 
      else if( $this.val() !== '' ) {
		    label.addClass('highlight');
			}
    }

});

$('.tab a').on('click', function (e) {
  
  e.preventDefault();
  
  $(this).parent().addClass('active');
  $(this).parent().siblings().removeClass('active');
  
  target = $(this).attr('href');

  $('.tab-content > div').not(target).hide();
  
  $(target).fadeIn(600);
  
});

$('#but0').on('click', function (e) {
  var uN = $('#regLogin')[0].value;
  var uE = $('#regEmail')[0].value;
  var uP = $('#regPass')[0].value;
  var uRN = $('#regRName')[0].value;
  if(uN.length > 0 && uE.length > 0 && uP.length > 0)
  {
      var form = new FormData();
      form.append('regLogin', uN);
      form.append('regEmail', uE);
      form.append('regPass', uP);
      form.append('regRName', uRN);
      $.ajax({
                  url: './method/regAction',
                  type: 'POST',
                  data: form,
                  cache: false,
                  dataType: 'html',
                  processData: false, // Не обрабатываем файлы (Don't process the files)
                  contentType: false, // Так jQuery скажет серверу что это строковой запрос
                  success: function( respond, textStatus, jqXHR ){
           
                      var rint = parseInt(respond);
                      // Если все ОК
                      switch (rint)
                      {
                        case 0: alert ('Успешная регистрция!');
                          break;
                        case 1: alert ('Пользователь с таким именем уже существует.');
                          break;
                      }
                  },
                  error: function( jqXHR, textStatus, errorThrown ){
                      console.log('ОШИБКИ AJAX запроса: ' + textStatus );
                  }
              });
  }
  else
    alert('Что-то не введено');

});


$('#but1').on('click', function (e) {
  var uN = $('#logLogin')[0].value;
  var uP = $('#logPass')[0].value;
  if(uN.length > 0 && uP.length > 0)
  {
      var form = new FormData();
      form.append('logLogin', uN);
      form.append('logPass', uP);
      $.ajax({
                  url: './method/getToken',
                  type: 'POST',
                  data: form,
                  cache: false,
                  dataType: 'html',
                  processData: false, // Не обрабатываем файлы (Don't process the files)
                  contentType: false, // Так jQuery скажет серверу что это строковой запрос
                  success: function( respond, textStatus, jqXHR ){
                      if(respond.length > 0)
                      {
                        document.cookie = "token="+respond;
                        $(location).attr('href','../wall');
                      }
                      else
                      {
                        alert('Вы ввели некорректные данные');
                      }
                  },
                  error: function( jqXHR, textStatus, errorThrown ){
                      console.log('ОШИБКИ AJAX запроса: ' + textStatus );
                  }
              });
  }
  else
    alert('Что-то не введено');
});

$('#fpass').on('click', function (e) {
  alert('Действие не назначено');
});