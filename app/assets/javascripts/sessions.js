$(function() {
  $('.login-modal-trigger').on('click', function(e) {
    e.preventDefault();
    $('.login-modal').toggleClass('hidden');
    $('.login-modal-trigger').toggleClass('is-toggled');
  })
});
