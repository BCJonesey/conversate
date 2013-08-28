$(function() {
  $('.grp-new-user-trigger').on('click', function(e) {
    e.preventDefault();
    var group = $(e.target).parents('.grp').first();
    group.find('.grp-new-user-form').removeClass('hidden');
  });
});
