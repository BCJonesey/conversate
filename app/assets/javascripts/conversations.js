(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .conversation-header");
    var titleEditor = header.find("form.title input[type='text']");
    var userEditor = header.find("form.users input[type='text']");

    // addressBook defined in index.html.erb.
    if (window.addressBook && window.participants) {
      tokenize(userEditor, addressBook, participants);
    }

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();

    var userIds = function() {
      return $.map($("form.users .token"), function(u) { return $(u).attr("data-token-id"); }).sort();
    };
    var currentUsers = userIds();

    titleEditor.on("blur", function(e) {
      if (titleEditor.val() == currentTitle) {
      }
      else {
        titleEditor.parents("form").submit();
      }
    });
    titleEditor.on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        if (titleEditor.val() == currentTitle) {
          e.stopPropagation();
          e.preventDefault();
        }
      }
    });

    $('html').on('click', function(e) {
      var target = $(e.target);
      console.log(target);
      if (target.closest('html').length > 0 &&
          target.closest('.token-container').length == 0) {
        var nowUsers = userIds();
        if (currentUsers.toString() !== nowUsers.toString()) {
          userEditor.val(nowUsers);
          userEditor.parents("form").submit();
        }
      }
    })
  };

  var setupCompose = function() {
    $("#compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        $("#compose form").submit();
        return false;
      }
    });
  };

  $(function() {
    setupConversationEditor();
    setupCompose();

    // Scroll the thread to the bottom when loading the page
    var thread = $('#thread');
    if (thread.length > 0) {
      thread.scrollTop(thread[0].scrollHeight - thread.height());
    }

    // The page will only open in editing mode if it's a new conversation.
    // new_conversation is defined in index.html.erb.
    if (window.new_conversation) {
      $('.conversation-header').click();
      $('form.users input[type="text"]').focus();
    }
    else {
      $('#compose textarea').focus();
    }


    $('.topics-group .topics-title').click(function(){
      $(this).parent().toggleClass('collapsed');
    });
  });
})();
