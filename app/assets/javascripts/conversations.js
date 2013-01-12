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

    $("#compose textarea").on("keydown", function(e) {
      if (e.keyCode == 13) { // Enter
        $("#compose form").submit();
        return false;
      }
    })
  });
})();

//scroll the thread to the bottom when laoding the page 

var s1 = $('#thread')[0].scrollHeight-$('#thread').height();	
$('#thread').scrollTop(s1);

// focus on the textarea.  This is most important when the page reloads afer submission

$("#compose textarea").focus();

$(document).ready(function(){
  $('.topics-group .topics-title').click(function(){
    $(this).parent().toggleClass('collapsed');
  });
});