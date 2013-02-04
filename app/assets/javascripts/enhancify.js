(function() {
  var imgify = function(match, continuation) {
    continuation('<div class="image-in-message"><a href="' + match.trim() + '" target="_blank"><img src="' + match.trim() + '"></img></a></div>');
  };

  var tweetify = function(match, continuation) {
    // JSONP requests don't have any error/complete callback.
    var error = setTimeout(function() {
      linkify(match, continuation);
    }, 5000);

    $.ajax('https://api.twitter.com/1/statuses/oembed.json?url=' + match.trim(),
           {crossDomain: true,
            dataType: 'jsonp',
            success: function(data) {
              clearTimeout(error);
              if (data.type == 'rich') {
                continuation(data.html);
              }
              else {
                linkify(match, continuation);
              }
            }
           });
  };

  var linkify = function(match, continuation) {
    var prefix = /^\s/.test(match) ? ' ' : '';
    continuation(prefix + '<a href="' + match.trim() + '" target="_blank">' + match.trim() + '</a>');
  };

  var enhancers = [
    {regex: /(\s+|^)https?:[^\s]+\.(jpg|jpeg|png|gif)/gi, enhance: imgify},
    {regex: /(\s+|^)https?:\/\/twitter\.com\/\S+\/status\/\d+/gi, enhance: tweetify},
    {regex: /(\s+|^)https?:[^\s]+/gi, enhance: linkify}
  ];

  $('.conversation-piece.message .message-text').each(function(messageIndex, text) {
    var nextEnhancer = function(enhancerIndex, enhancedHTML) {
      if (enhancerIndex >= enhancers.length) {
        $(text).html($.parseHTML(enhancedHTML, document, true));
        return;
      }

      var enhancer = enhancers[enhancerIndex];
      // Note that |splits| == |matches| + 1.
      var matches = enhancedHTML.match(enhancer.regex);
      if (!matches) {
        nextEnhancer(enhancerIndex + 1, enhancedHTML);
        return;
      }

      var splits = enhancedHTML.split(enhancer.regex);
      var i = 0;
      var enhanced = splits[0];
      var continuation = function(replacement) {
        enhanced += replacement;
        i++;
        enhanced += splits[i]
        if (i < matches.length) {
          enhancer.enhance(matches[i], continuation);
        }
        else {
          nextEnhancer(enhancerIndex + 1, enhanced);
        }
      }
      enhancer.enhance(matches[0], continuation);
    }
    nextEnhancer(0, text.innerHTML);
  });
})();
