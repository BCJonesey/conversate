Support.TextEnhancer = {
  enhance: function(text) {
    var regex = /(?:^|[^"])https?:[^\s]+[^.,!?\s]/gi;
    return text.replace(regex, this._linkify);
  },
  _linkify: function(match) {
    var prefix = '';
    if (match.substring(0, 4) !== 'http') {
      prefix = match[0];
      match = match.substring(1);
    }

    var suffix = '';
    if (match[match.length - 1] === ')') {
      var open = (match.match(/\(/g) || []).length;
      var close = (match.match(/\)/g) || []).length;
      if (close === open + 1) {
        suffix = ')';
        match = match.substring(0, match.length - 1);
      }
    }

    return prefix + '<a href="' + match.trim() + '" target="_blank">' + match.trim() + '</a>' + suffix;
  }
}
