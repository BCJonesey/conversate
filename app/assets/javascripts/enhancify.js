(function() {
  var imgify = function(match, continuation) {
    var url = match.trim();
    var src = match.trim();

    // Dropbox makes some funky links
    if (/^https:\/\/www\.dropbox\.com/.test(src)) {
      src = src.replace(/^https:\/\/www/, 'http://dl');
    }

    continuation('<div class="image-in-message"><a href="' + url + '" target="_blank"><img src="' + src + '"></img></a></div>');
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

  var youtubify = function(match, continuation) {
    var videoId = match.match(/v=\w+/);
    if (!videoId) {
      continuation(match);
    }

    videoId = videoId[0].substring(2);
    continuation('<iframe width="420" height="315" src="http://www.youtube.com/embed/' + videoId + '" frameborder="0" allowfullscreen></iframe>');
  }

  var vimeofy = function(match, continuation) {
    var videoId = match.match(/\/\d+/);
    if (!videoId) {
      continuation(match);
    }

    videoId = videoId[0].substring(1);
    continuation('<iframe src="http://player.vimeo.com/video/' + videoId + '" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>');
  }

  // Sean registered Water Cooler with SoundCloud.  App page at
  // https://soundcloud.com/you/apps/water-cooler/edit.  As far as he can tell,
  // there isn't a way to share an app with other SoundCloud accounts.
  var soundCloudClientId = "d68b4da268565a405c24695b94fb690d";
  var soundcloudify = function(match, continuation) {
    // JSONP requests don't have any error/complete callback.
    var error = setTimeout(function() {
      linkify(match, continuation);
    }, 5000);

    var url = 'http://api.soundcloud.com/resolve.json?url=' + match.trim() +
              '&client_id=' + soundCloudClientId;
    $.getJSON(url, function(track) {
      clearTimeout(error);
      var embed = '<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F' + track.id + '"></iframe>';
      continuation(embed);
    })
  };

  var colorify = function(match, continuation) {
    var swatch = '<span class="color-swatch" style="background-color: ' + match.trim() +
                 '">&nbsp;</span>';
    continuation(' ' + swatch + match);
  }

  var codepenify = function(match, continuation) {
    var id = match.substring(match.lastIndexOf('/') + 1);
    var user = /^.?http:\/\/codepen.io\/(\S+?)\//.exec(match)[1];
    embed = '<pre class="codepen" data-height="300" data-type="result" data-href="' + id + '" data-user="' + user + '" data-safe="true"><code></code></pre><script async src="http://codepen.io/assets/embed/ei.js"></script>';
    continuation(embed);
  }

  var linkify = function(match, continuation) {
    var prefix = "";
    if (match.substring(0, 4) != "http") {
      prefix = match[0];
      match = match.substring(1);
    }

    var suffix = "";
    if (match[match.length - 1] == ")") {
      var openCount = (match.match(/\(/g) || []).length;
      var closeCount = (match.match(/\)/g) || []).length;
      if (closeCount == openCount + 1) {
        suffix = ")";
        match = match.substring(0, match.length - 1);
      }
    }

    continuation(prefix + '<a href="' + match.trim() + '" target="_blank">' + match.trim() + '</a>' + suffix);
  };

  var enhancers = [
    {regex: /(^|[^"])https?:[^\s]+\.(jpg|jpeg|png|gif)/gi, enhance: imgify},
    {regex: /(^|[^"])https?:\/\/twitter\.com\/\S+\/status\/\d+/gi, enhance: tweetify},
    {regex: /(?:^|[^"])https?:\/\/www\.youtube\.com\/watch\?[^\s,.!?()]+/gi, enhance: youtubify},
    {regex: /(?:^|[^"])https?:\/\/vimeo\.com\/\d+/gi, enhance: vimeofy},
    {regex: /(?:^|[^"])https?:\/\/soundcloud\.com\/\S+\/\S+/gi, enhance: soundcloudify},
    // TODO: This color regex seems to cause lots of problems.  Fix it at some point.
    //{regex: /(?:^|\s)(#[0-9A-fa-f]{6}|#[0-9A-Fa-f]{3}|(?:rgb|hsl)a?)\([,\d%\s\.]+\)/gi, enhance: colorify},
    {regex: /(?:^|[^"])http:\/\/codepen\.io\/\S+\/(?:pen|full)\/\S+/gi, enhance: codepenify},
    {regex: /(?:^|[^"])https?:[^\s]+[^.,!?\s]/gi, enhance: linkify}
  ];

  var enhancify = function(target) {
    target.find('.msg-text').each(function(messageIndex, text) {
      var nextEnhancer = function(enhancerIndex, enhancedHTML) {
        if (enhancerIndex >= enhancers.length) {
          $(text).html($.parseHTML(enhancedHTML, document, true));

          // Wait until (hopefully) all the 3rd-party fancy js stuff is loaded
          setTimeout(function() { Scroller.scrollToBottom($('#thread')); },
                     1000);
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
          // There seems to be a problem with String.split that creates
          // entries that are part of a match...
          if (!(splits[i] == replacement.substring(0, splits[i].length))) {
            enhanced += splits[i]
          }
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
  }

  window.Enhancer = {enhancify: enhancify};
})();
