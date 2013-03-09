(function() {
  var topicNew = function() {
    $('.topic-new').removeClass('hidden')
    $('.topic-new-input').focus().val('');
  };

  var enterMoveConversationMode = function() {
    $('.topics').addClass('move-targets');
    $('.topics .topic').on('click', function(e) {
      e.preventDefault();
      var id = $(e.target).closest('.topic').attr('data-topic-id');
      var topicForm = $('#change-topic');
      topicForm.find('input[name="topic"]').val(id);
      topicForm.submit();
    });
    $('.cnv-info-move-cnv').on('click', leaveMoveConversationMode);
  };

  var leaveMoveConversationMode = function() {
    $('.topics').removeClass('move-targets');
    $('.topics .topic').off('click');
    $('.cnv-info-move-cnv').on('click', enterMoveConversationMode);
  };

  $(function() {
    $('.topic-new-button').on('click', topicNew);
    $('.cnv-info-move-cnv').live('click', enterMoveConversationMode);
  });
})();
