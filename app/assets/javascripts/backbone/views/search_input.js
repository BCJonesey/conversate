Structural.Views.SearchInput = Support.CompositeView.extend({
  className: 'search-input',
  template: JST.template('search/input'),
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.template());
  }
});
