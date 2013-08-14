$(function() {
  $('.grp-remove-user-trigger, .grp-unremove-user-trigger').on('click', function(e) {
    e.preventDefault();
    $(e.target).parents().first().find('a, i').toggleClass('hidden');
  })
});
