$(function() {
  $('.login-modal-trigger').on('click', function(e) {
    e.preventDefault();
    $('.login-modal').toggleClass('hidden');
    $('.login-modal-trigger').toggleClass('is-toggled');
  })

  $('.sub-nav-item').click(function(e){
    e.preventDefault();
    $('.sub-nav-item.is-selected').removeClass('is-selected');
    $(this).addClass('is-selected');
  });
});
