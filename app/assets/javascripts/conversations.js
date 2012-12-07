(function() {
  var nearestWithClass = function(klass, element) {
    if (element.hasClass(klass)) {
      return element;
    }

    return element.parents("." + klass).first();
  };

  $(function() {
    $(".delete-message").on("click", function(e) {
      e.preventDefault();
      $("#" + nearestWithClass("delete-message", $(e.target)).attr("data-delete-target"))
        .submit();
    });
  });
})();
