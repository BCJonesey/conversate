//= require ./text

// Adapted from http://jmrware.com/articles/2010/linkifyurl/linkify.html
Structural.Data.Text._surroundUrls = function(text) {
    var url_pattern = /(\()((?:ht|f)tps?:\/\/[a-z0-9\-._~!$&'()*+,;=:\/?#[\]@%]+)(\))|(\[)((?:ht|f)tps?:\/\/[a-z0-9\-._~!$&'()*+,;=:\/?#[\]@%]+)(\])|(\{)((?:ht|f)tps?:\/\/[a-z0-9\-._~!$&'()*+,;=:\/?#[\]@%]+)(\})|(<|&(?:lt|#60|#x3c);)((?:ht|f)tps?:\/\/[a-z0-9\-._~!$&'()*+,;=:\/?#[\]@%]+)(>|&(?:gt|#62|#x3e);)|((?:^|[^=\s'"\]])\s*['"]?|[^=\s]\s+)(\b(?:ht|f)tps?:\/\/[a-z0-9\-._~!$'()*+,;=:\/?#[\]@%]+(?:(?!&(?:gt|#0*62|#x0*3e);|&(?:amp|apos|quot|#0*3[49]|#x0*2[27]);[.!&',:?;]?(?:[^a-z0-9\-._~!$&'()*+,;=:\/?#[\]@%]|$))&[a-z0-9\-._~!$'()*+,;=:\/?#[\]@%]*)*[a-z0-9\-_~$()*+=\/#[\]@%])/img;
    return text.replace(url_pattern,
        function ($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) {
          var len = arguments.length;
          for (var i = 0; i < len; ++i) {
            if (arguments[i] === undefined) arguments[i] = "";
          }
          var pre  = $1+$4+$7+$10+$13;
          var url  = $2+$5+$8+$11+$14;
          var post = $3+$6+$9+$12;
          if (allBalanced(url)) {
            return pre + '\u001E' + url + '\u001E'+ post;
          } else {
            // Fixup urls ending with orphan "]" or "}"
            switch (url.slice(-1)) {
            case ')':
              if (!parensBalanced(url)) {
                if (parensBalanced(url.slice(0,-1))) {
                  url = url.slice(0,-1);
                  post = ')'+ post
                }
              }
              if (!bracketsBalanced(url)) {
                if (bracketsBalanced(url.slice(0,-1))) {
                  url = url.slice(0,-1);
                  post = ']'+ post
                }
              }
              break;
            case ']':
              if (!bracketsBalanced(url)) {
                if (bracketsBalanced(url.slice(0,-1))) {
                  url = url.slice(0,-1);
                  post = ']'+ post
                }
              }
              if (!parensBalanced(url)) {
                if (parensBalanced(url.slice(0,-1))) {
                  url = url.slice(0,-1);
                  post = ')'+ post
                }
              }
              break;
            }
          }
          if (allBalanced(url)) {
            return pre + '\u001E' + url + '\u001E' + post;
          } else return $0;
        });
  function allBalanced(url) {
    return parensBalanced(url) && bracketsBalanced(url);
  }
  function parensBalanced(url) {
      var re = /\([^()]*\)/g;
        while (url.search(re) !== -1) {
          url = url.replace(re, '');
        }
    if (url.search(/[()]/) === -1) return true;
    return false;
  }
  function bracketsBalanced(url) {
      var re = /\[[^[\]]*\]/g;
        while (url.search(re) !== -1) {
          url = url.replace(re, '');
        }
    if (url.search(/[[\]]/) === -1) return true;
    return false;
  }

  function bracket2entity(text) {
    return text.replace(/[()[\]]/g,
      function(m0){
        return {
          '(':'&#40;',
          ')':'&#41;',
          '[':'&#91;',
          ']':'&#93;', }[m0];
      })
  }
  function entity2bracket(text) {
    return text.replace(/&#(?:4[01]|9[13]);/g,
      function(m0){
        return {
          '&#40;':'(',
          '&#41;':')',
          '&#91;':'[',
          '&#93;':']',
          }[m0];
      })
  }
}
