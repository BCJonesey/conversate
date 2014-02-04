Structural.Collections.SearchResults = Backbone.Collection.extend({
  model: Structural.Models.SearchResult,
  url: function() {
    return Structural.apiPrefix + '/search?query=' +
           encodeURIComponent(this._query);
  },
  initialize: function(data, options) {

  },
  comparator: function(searchResult) {
    return - (searchResult.get('rank'));
  },

  search: function(query) {
    this._query = query;
    this.fetch();
  }
});
