(function() {
  var setupConversationEditor = function() {
    var header = $("#column-conversation .conversation-header");
    var titleEditor = header.find("form.title input[type='text']");
    var userEditor = header.find("form.users input[type='text']");

    // addressBook defined in index.html.erb.
    tokenize(userEditor, addressBook, participants);

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();

    var userIds = function() {
      return $.map($("form.users .token"), function(u) { return $(u).attr("data-token-id"); }).sort();
    }
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
    }

    var closeIfOutside = function(e) {
      if ($(e.target).parents(".conversation-header").length > 0 ||
          $(e.target).closest("html").length == 0) {
        e.preventDefault();
        e.stopPropagation();
        return;
      }
      close();
    }

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
      if (e.keyCode == 13) { // Enter
        $("#compose form").submit();
        return false;
      }
    });
  };

  $(function() {
    setupConversationEditor();
    setupMessageMenus();
    setupCompose();
  });
})();

/* scroll the thread to the bottom when laoding the page */

var s1 = $('#thread')[0].scrollHeight-$('#thread').height();	
$('#thread').scrollTop(s1);

/* focus on the textarea.  This is most important when the page reloads afer submission */

$("#compose textarea").focus();
