Structural.Views.SearchResults = Support.CompositeView.extend({
  className: 'search-results',
  templates: {
    'noSearch': JST.template('search/nosearch'),
    'inProgress': JST.template('search/progress'),
    'completed': JST.template('search/results'),
  },
  initialize: function(options) {
    this._results = options.results ||
                    new Structural.Collections.SearchResults([]);
    this._results.on('sync', this.searchCompleted, this);

    this._query = "";
    this._searchStatus = 'noSearch';
  },
  render: function() {
    this.$el.html(this.templates[this._searchStatus]({
      results: this._results,
      query: this._query
    }));

    this._results.forEach(this.renderResult, this);
  },
  renderResult: function(result) {
    var view = new Structural.Views.SearchResult({
      model: result
    });
    view.on('resultViewed', function() {
      this.trigger('resultViewed');
    }, this);

    this.appendChildTo(view, this.$('.search-results-list'))
  },

  search: function(query) {
    this._query = query.trim();

    if (this._query.length === 0) {
      this._searchStatus = 'noSearch';
    } else {
      this._results.search(this._query);
      this._searchStatus = 'inProgress'
    }

    this.render();
  },
  searchCompleted: function() {
    this._searchStatus = 'completed';
    this.render();
  }
});
