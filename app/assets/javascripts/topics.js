(function() {

  function topicEditStart(){
    $('.topic-new-input').val('');
  }

  function topicEditStop(){
    $('.topic-new-input').val('New Topic');
  }

  $(function() {
    $('.topic-new-input').on('focus', topicEditStart);
    $('.topic-new-input').on('blur', topicEditStop);
  });
})();
