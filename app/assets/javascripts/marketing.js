$(function() {
  var toggle = $('.mkt-sign-in-toggle');
  toggle.on('click', function(e) {
    e.preventDefault();
    var form = $('.login-modal');

    toggle.toggleClass('is-toggled');
    form.toggleClass('hidden');
  });

  // This way we don't attach a needless event on a page without this button.
  toggle.parents('body').on('click', function(e) {
    e.preventDefault();
    var target = $(e.target);
    if (toggle.hasClass('is-toggled') && target.closest('.login-modal, .mkt-sign-in-toggle').length === 0) {
      toggle.toggleClass('is-toggled');
      $('.login-modal').toggleClass('hidden');
    }
  })
})
