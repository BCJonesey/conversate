Structural.Views.SearchResult = Support.CompositeView.extend({
  tagName: 'li',
  className: 'search-result',
  template: JST.template('search/result'),
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.template({
      result: this.model
    }));
  }
});
