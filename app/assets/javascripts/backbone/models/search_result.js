Structural.Models.SearchResult = Backbone.Model.extend({
  initialize: function(attributes, options) {
    this.set('joinedHeadline', this._getJoinedHeadline());
  },

  _highlightPrefix: "<span class=\"search-result-headline-highlight\">",
  _highlightSuffix: "</span>",
  /* Takes an array of headline fragments (starting with a non-highlighted
     fragment) and escapes and joins them into a chunk of headline html.
     Effectively reverses the process from SearchResult#split_headline on the
     server. */
  _getJoinedHeadline: function() {
    var fragments = this.get('headline');
    var escaped = _.map(fragments, _.escape);
    var tagged = _.map(escaped, this._tagFragment, this);
    return tagged.join('');
  },
  _tagFragment: function(fragment, index) {
    if (index % 2 === 1) {
      return this._highlightPrefix + fragment + this._highlightSuffix;
    } else {
      return fragment;
    }
  }
})
