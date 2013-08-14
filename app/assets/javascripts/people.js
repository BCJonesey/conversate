$(function() {
  $('.grp-remove-user-trigger, .grp-unremove-user-trigger').on('click', function(e) {
    e.preventDefault();
    var cell = $(e.target).parents().first();
    cell.find('a, i').toggleClass('hidden');

    if(cell.find('.grp-remove-user-trigger').hasClass('hidden')) {
      cell.find('input').attr('checked', 'checked');
    } else {
      cell.find('input').removeAttr('checked');
    }
  })
});
