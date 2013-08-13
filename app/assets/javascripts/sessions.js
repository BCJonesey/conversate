$(function() {
  $('.login-modal-trigger').on('click', function(e) {
    e.preventDefault();
    $('.login-modal').toggleClass('hidden');
  })
});
