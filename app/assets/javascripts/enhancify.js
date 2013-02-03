(function() {
  var imgify = function(match) {
    return '<div class="image-in-message"><img src="' + match.trim() + '"></img></div>';
  };

  var linkify = function(match) {
    return '<a href="' + match.trim() + '">' + match.trim() + '</a>';
  };

  var enhancers = [
    {regex: /(\s+|^)https?:[^\s]+\.(jpg|jpeg|png|gif)/gi, enhance: imgify},
    {regex: /(\s+|^)https?:[^\s]+/gi, enhance: linkify}
  ];

  $('.conversation-piece.message .message-text').each(function(messageIndex, text) {
    enhancers.forEach(function(enhancer) {
      var enhanced = text.innerHTML.replace(enhancer.regex, enhancer.enhance);
      text.innerHTML = enhanced;
    });
  });
})();
