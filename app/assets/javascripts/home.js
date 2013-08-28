$(function() {
  $('.home-entrance-toggle').on('click', function(e) {
    e.preventDefault();

    if ($('.home-form-speakeasy').hasClass('hidden')) {
      $('.home-entrance-toggle').text('Sign In');
    } else {
      $('.home-entrance-toggle').text('Just Browsing');
    }

    $('.home-form-speakeasy, .home-form-sign-in').toggleClass('hidden');
  })
})