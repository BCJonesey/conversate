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
    });

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


$(document).ready(function(){
    var s1 = $('#thread')[0].scrollHeight-$('#thread').height();	
		$('#thread').scrollTop(s1);
});
