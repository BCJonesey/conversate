$(function() {
  $('body').on('click', '.tour-page', function(e){

    var image = $(e.target).closest('.help-screenshot');

    if (image.hasClass('is-bigger')){
      $('.tour-page .help-screenshot.is-bigger').removeClass('is-bigger');
    } else {
      image.addClass('is-bigger');
    }

  });
})
