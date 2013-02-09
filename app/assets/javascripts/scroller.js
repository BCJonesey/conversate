(function() {
  var scrollToBottom = function(target) {
    var height = target.scrollHeight || target[0].scrollHeight;
    target.scrollTop(height);
  };

  var atBottom = function(target) {
    return target.scrollTop() >= (target[0].scrollHeight - target.outerHeight());
  }

  window.Scroller = {
    scrollToBottom: scrollToBottom,
    atBottom: atBottom
  };
})();
