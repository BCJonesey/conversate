Structural.Views.Search = Support.CompositeView.extend({
  className: 'search',
  template: JST.template('search/search'),
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
});
