Structural.Views.SearchResults = Support.CompositeView.extend({
  className: 'search-results',
  template: JST.template('search/results'),
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.template());
  },

  search: function(query) {
    // TODO: Search
  }
});
