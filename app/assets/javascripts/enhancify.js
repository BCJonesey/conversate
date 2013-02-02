(function() {
  var linkify = function(match) {
    return '<a href="' + match + '">' + match + '</a>';
  }

  var enhancers = [
    {regex: /https?:[^\s]+/gi, enhance: linkify}
  ];

  $('.conversation-piece.message .message-text').each(function(messageIndex, text) {
    enhancers.forEach(function(enhancer) {
      var enhanced = text.innerText.replace(enhancer.regex, enhancer.enhance);
      text.innerHTML = enhanced;
    });
  });
})();
