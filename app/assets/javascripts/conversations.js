(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .conversation-info");
    var titleEditor = header.find("form.title input[type='text']");
    var userEditor = header.find("form.participants input[type='text']");

    // addressBook defined in index.html.erb.
    if (window.addressBook && window.participants) {
      tokenize(userEditor, addressBook, participants);
    }

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();

    var userIds = function() {
      return $.map($("form.participants .token"), function(u) { return $(u).attr("data-token-id"); }).sort();
    };
    var currentUsers = userIds();

    titleEditor.on("blur", function(e) {
      titleEditor.parents("form").submit();
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
      if (target.closest('html').length > 0 &&
          target.closest('.token-container').length == 0) {
        var nowUsers = userIds();
        if (currentUsers.toString() !== nowUsers.toString()) {
          userEditor.hide();
          userEditor.val(nowUsers);
          userEditor.parents("form").submit();
        }
      }
    })
  };

  var setupCompose = function() {
    $("#short-form-compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        $("#short-form-compose form").submit();
        return false;
      }
    });

    $("#enable-long-form").on('click', function(e) {
      $("#long-form-compose").addClass("open");
    });

    $("#disable-long-form").on('click', function(e) {
      $("#long-form-compose").removeClass("open");
    })
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
      $('.conversation-info').click();
      $('form.participants input[type="text"]').focus();
    }
    else {
      $('#short-form-compose textarea').focus();
    }


    $('.topics-group .topics-title').click(function(){
      $(this).parent().toggleClass('collapsed');
    });

    $('#column-list').css('left', $('#column-navigation').outerWidth() + 1);
    $('#column-conversation').css('left',
      $('#column-navigation').outerWidth() + $('#column-list').outerWidth() + 2);
    $('#column-list #conversations-list').css('top', $('#column-list #list-header').outerHeight());
  });

  // Writes a single messages from short form compose to our local collection
  // and back to the server.
  var send_message = function (e) {
    var message = {
      type: 'message',
      // We can do this here for instant message population, but the server
      // should pay no heed to it.
      user: ConversateApp.current_user,
      timestamp: Date.now(),
      count: 1,
      text: $('#write-text').val()
    }
    if (ConversateApp.messages.create(message)) {
      $('#write-text').val('');
    }
    else {
      console.log('Error: There was problem sending the last message.')
    }
  };

  $('#send').live('click', send_message);
  $('#write-text').live('keyup', function (e) {
    if (e.keyCode == 13) {
      send_message();
    }
  });



})();
