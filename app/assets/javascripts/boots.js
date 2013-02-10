$('.msg-delete').click(function(e){
  $(this).parents('.message').find('form').submit();
});
