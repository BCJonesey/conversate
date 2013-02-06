(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .cnv-info");
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

    titleEditor.on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        if (titleEditor.val() == currentTitle) {
          e.stopPropagation();
          e.preventDefault();
        }
      }
    });

    $('.cnv-info-participants-save').on('click', function(e) {
      var nowUsers = userIds();
      if (currentUsers.toString() !== nowUsers.toString()) {
        userEditor.hide();
        userEditor.val(nowUsers);
        userEditor.parents("form").submit();
      }
    });
  }

  var setupCompose = function() {
    $("#short-form-compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        $("#short-form-compose form").submit();
        return false;
      }
    });

    $("#enable-long-form").on('click', function(e) {
      $("#long-form-compose").addClass("open");
      $('#long-form-compose textarea').focus().val($('#short-form-compose textarea').val());

    });

    $("#disable-long-form").on('click', function(e) {
      $('#short-form-compose textarea').focus().val($('#long-form-compose textarea').val());
      $("#long-form-compose").removeClass("open");
    })
  };

  var setupMessageActions = function() {
    $('.msg-delete').live('click', function(e) {
      var id = $(e.target).closest('.msg-delete').attr('data-message-id');
      $('#form-delete-' + id).submit();
    });
  }

  $(function() {
    setupConversationEditor();
    setupCompose();
    setupMessageActions();

    // Scroll the thread to the bottom when loading the page
    var thread = $('#thread');
    if (thread.length > 0) {
      thread.scrollTop(thread[0].scrollHeight - thread.height());
    }

    // The page will only open in editing mode if it's a new conversation.
    // new_conversation is defined in index.html.erb.
    if (window.new_conversation) {
      $('.cnv-info .cnv-info-title-input').click();
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
  });
})();
