$(function() {
  $('body').on('click', '.modal-message-dismiss', function(e) {
    e.preventDefault();
    $(e.target).parents('.modal-background').first().addClass('hidden');
  })
})
