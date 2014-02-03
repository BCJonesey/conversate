Structural.Views.SearchInput = Support.CompositeView.extend({
  className: 'search-input',
  template: JST.template('search/input'),
  initialize: function(options) {
    this._query = options.query || "";
  },
  render: function() {
    this.$el.html(this.template());
  }
});
