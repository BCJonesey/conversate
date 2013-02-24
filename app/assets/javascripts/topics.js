(function() {
  function topicNew(){
    $('.topic-new').removeClass('hidden')
    $('.topic-new-input').focus().val('');
  }

  $(function() {
    $('.topic-new-button').on('click', topicNew);
  });
})();
