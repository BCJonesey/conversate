$(function() {
  $('.mkt-sign-in-toggle').on('click', function(e) {
    e.preventDefault();
    var toggle = $(e.target);
    var form = $('.login-modal');

    toggle.toggleClass('is-toggled');
    form.toggleClass('hidden');
  })
})
