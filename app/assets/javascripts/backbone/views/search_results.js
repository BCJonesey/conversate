Structural.Views.SearchResults = Support.CompositeView.extend({
  className: 'search-results',
  template: JST.template('search/results'),
  initialize: function(options) {
    this._results = options.results ||
                    new Structural.Collections.SearchResults([]);
    this._results.on('sync', this.render, this);
  },
  render: function() {
    this.$el.html(this.template({
      results: this._results
    }));

    this._results.forEach(this.renderResult, this);
  },
  renderResult: function(result) {
    var view = new Structural.Views.SearchResult({
      model: result
    });
    this.appendChildTo(view, this.$('.search-results-list'))
  },

  search: function(query) {
    this._results.search(query);
  }
});
