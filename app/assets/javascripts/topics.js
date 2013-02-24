(function() {
  var topicNew = function() {
    $('.topic-new').removeClass('hidden')
    $('.topic-new-input').focus().val('');
  };

  $(function() {
    $('.topic-new-button').on('click', topicNew);
  });
})();
