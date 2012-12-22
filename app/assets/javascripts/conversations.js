(function() {
  $(function() {
    var title = $("#column-conversation .title");
    var titleEditor = title.find("input[type='text']");
    title.on("click", function() {
      title.addClass("editing");
      titleEditor.focus();
    });
    titleEditor.on("blur", function() {
      if (titleEditor.val() == title.find(".text").text()) {
        title.removeClass("editing");
      }
      else {
        title.find("form").submit();
      }
    });
    titleEditor.on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        if (titleEditor.val() == title.find(".text").text()) {
          e.stopPropagation();
          e.preventDefault();
          title.removeClass("editing");
        }
      }
    })
  })
})();
