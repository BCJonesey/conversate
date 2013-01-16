(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .conversation-header");
    var titleEditor = header.find("form.title input[type='text']");
    var userEditor = header.find("form.users input[type='text']");

    // addressBook defined in index.html.erb.
    var addressBook = addressBook || [];
    var participants = participants || [];
    tokenize(userEditor, addressBook, participants);

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();

    var userIds = function() {
      return $.map($("form.users .token"), function(u) { return $(u).attr("data-token-id"); }).sort();
    };
    var currentUsers = userIds();

    var close = function() {
      header.removeClass("editing");
      titleEditor.off("blur");
      titleEditor.off("keydown");
      $(window).off("click");

      var nowUsers = userIds();
      if (currentUsers.toString() !== nowUsers.toString()) {
        userEditor.val(nowUsers);
        userEditor.parents("form").submit();
      }
    };

    var closeIfOutside = function(e) {
      if ($(e.target).parents(".conversation-header").length > 0 ||
          $(e.target).closest("html").length == 0) {
        e.preventDefault();
        e.stopPropagation();
        return;
      }
      close();
    };

    titleEditor.on("focus", function() {
      if (!header.hasClass("editing")) {
        titleEditor.blur();
      }
    });

    header.on("click", function(e) {
      if (header.hasClass("editing")) { return; }

      e.stopPropagation();
      e.preventDefault();
      header.addClass("editing");

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
            header.removeClass("editing");
            titleEditor.off("blur");
            titleEditor.off("keydown");
          }
        }
      });

      $(window).on("click", function(e) {
        closeIfOutside(e)
      });
    });
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

    // Focus on the textarea.  This most important when the page reloads after
    // submission.
    $('#compose textarea').focus();

    $('.topics-group .topics-title').click(function(){
      $(this).parent().toggleClass('collapsed');
    });
  });
})();
