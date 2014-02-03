Structural.Views.SearchResults = Support.CompositeView.extend({
  className: 'search-results',
  template: JST.template('search/results'),
  initialize: function(options) {
    this._results = options.results ||
                    new Structural.Collections.SearchResults([]);
  },
  render: function() {
    this.$el.html(this.template({
      results: this._results
    }));
  },

  search: function(query) {
    // TODO: Search
  }
});
