$(function() {
  $('body').on('click', '.tour-page', function(e){

    var image = $(e.target).closest('.help-screenshot');

    if (image.hasClass('is-bigger')){
      $('.tour-page .help-screenshot.is-bigger').removeClass('is-bigger');
    } else {
      $('.tour-page .help-screenshot.is-bigger').removeClass('is-bigger');
      image.addClass('is-bigger');
    }
  });
})
