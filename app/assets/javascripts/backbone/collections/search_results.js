Structural.Collections.SearchResults = Backbone.Collection.extend({
  model: Structural.Models.SearchResult,
  url: function() {
    return Structural.apiPrefix + '/search?query=' +
           encodeURIComponent(this._query);
  },
  initialize: function(data, options) {

  },
  comparator: function(searchResult) {
    return -(searchResult.get('rank'));
  },
  parse: function(response) {
    this._queryFromResponse = response.query;
    return response.results;
  },
  set: function(models, options) {
    if (options.parse) {
      models = this.parse(models, options);
      options.parse = false;
    }

    if (this._query === this._queryFromResponse) {
      return this.constructor.__super__.set.call(this, models, options);
    }
  },

  search: function(query) {
    this._query = query;
    this.fetch();
  }
});
