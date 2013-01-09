(function() {
  var setupTitleEditor = function() {
    var title = $("#column-conversation .title");
    var titleEditor = title.find("input[type='text']");

    // TODO: Once this is done via AJAX instead of page refresh, update
    // currentTitle on title change.
    var currentTitle = titleEditor.val();
    title.on("click", function() {
      title.addClass("editing");
      titleEditor.focus();
    });
    titleEditor.on("blur", function() {
      if (titleEditor.val() == currentTitle) {
        title.removeClass("editing");
      }
      else {
        title.find("form").submit();
      }
    });
    titleEditor.on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        if (titleEditor.val() == currentTitle {
          e.stopPropagation();
          e.preventDefault();
          title.removeClass("editing");
        }
      }
    });
  }

  $(function() {
    setupTitleEditor();

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

    $("#compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13 && e.ctrlKey) { // Enter
        $("#compose form").submit();
      }
    })
  });
})();
