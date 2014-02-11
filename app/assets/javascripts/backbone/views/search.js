Structural.Views.Search = Support.CompositeView.extend({
  tagName: 'span',
  className: 'search-wrap popover-wrap',
  template: JST.template('search/search'),
  initialize: function(options) {
    options = options || {}

    this._input = new Structural.Views.SearchInput({
      query: options.query
    });
    this._results = new Structural.Views.SearchResults({
      results: options.results
    });

    Structural.on('clickAnywhere', this.hideAndClear, this);
    this._results.on('resultViewed', this.hide, this);
  },
  render: function() {
    this.$el.html(this.template());

    var content = this.$('.popover-content');
    this.appendChildTo(this._input, content);
    this.appendChildTo(this._results, content);

    this._input.on('queryChanged', this._results.search, this._results);

    return this;
  },
  events: {
    'click .search-toggle': 'toggleSearch'
  },

  toggleSearch: function(e) {
    if (e) { e.preventDefault(); }

    this.$('.search-popover').toggleClass('hidden');
    this.$('.search-toggle').toggleClass('active');

    if (this.isOpen()) {
      this._input.focus();
    }
  },
  isOpen: function() {
    return !this.$('.search-popover').hasClass('hidden');
  },
  hide: function(e) {
    var target = e ? $(e.target) : undefined;
    if (!target ||
        (target.closest('.search-wrap').length === 0 && this.isOpen())) {
      this.toggleSearch();
      return true;
    } else {
      return false;
    }
  },
  hideAndClear: function(e) {
    if (this.hide(e)) {
      this._input.clear();
      this._results.clear();
    }
  }
});
