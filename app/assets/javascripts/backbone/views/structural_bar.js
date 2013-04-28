Structural.Views.StructuralBar = Support.CompositeView.extend({
  className: 'structural-bar clearfix',
  template: JST['backbone/templates/structural/structural_bar'],
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.$el.html(this.template({user: this.model}));
    return this;
  }
});
