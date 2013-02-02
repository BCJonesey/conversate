(function() {
  var imgify = function(match) {
    return '<img src="' + match.trim() + '" class="user-image"></img>';
  };

  var linkify = function(match) {
    return '<a href="' + match.trim() + '">' + match + '</a>';
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
