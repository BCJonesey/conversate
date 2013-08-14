$(function() {
  $('.modal-message-dismiss').on('click', function(e) {
    e.preventDefault();
    $(e.target).parents('.modal-background').first().remove();
  })
})
