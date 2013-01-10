(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .conversation-header");
    var titleEditor = header.find("form.title input[type='text']");
    var userEditor = header.find("form.users input[type='text']");

    tokenize(userEditor, [{id: 1, name: 'Josh Lyman'}])

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();

    titleEditor.on("focus", function() {
      if (!header.hasClass("editing")) {
        titleEditor.blur();
      }
    });

    header.on("click", function(e) {
      if (header.hasClass("editing")) { return; }

      header.addClass("editing");

      titleEditor.on("blur", function() {
        if (titleEditor.val() == currentTitle) {
          header.removeClass("editing");
          titleEditor.off("blur");
          titleEditor.off("keydown");
          titleEditor.attr("readonly", "true");
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
            titleEditor.attr("readonly", "true");
          }
        }
      });
    });

  };

  var setupMessageMenus = function() {
    $(".conversation-piece.message").on("click", function(e) {
      var target = $(e.target);
      if (!target.hasClass("conversation-piece")) {
        target = target.parents(".conversation-piece").first();
      }

      if (target.hasClass("active")) {
        e.stopPropagation();
        return;
      }

      target.addClass("active");
      target.find(".message-actions").slideDown(250, function() {
        $(window).on("click", function() {
          target.removeClass("active");
          target.find(".message-actions").slideUp(250);
          $(window).off("click");
        });
      });
    });
  };

  var setupCompose = function() {
    $("#compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13 && e.ctrlKey) { // Enter
        $("#compose form").submit();
      }
    });
  };

  $(function() {
    setupConversationEditor();
    setupMessageMenus();
    setupCompose();
  });
})();
