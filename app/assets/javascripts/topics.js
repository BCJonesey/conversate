(function() {

  function topicNew(){
    $('.topic-new').removeClass('hidden')
    $('.topic-new-input').focus().val('');
  }

  // function topicEditStop(){
  //   $('.topic-new-input').val('New Topic');
  // }

  $(function() {
    $('.topic-new-button').on('click', topicNew);
    //$('.topic-new-input').on('blur', topicEditStop);
  });
})();
