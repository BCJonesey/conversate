Structural.Views.StructuralBar = Support.CompositeView.extend({
  className: 'structural-bar clearfix',
  template: JST['backbone/templates/structural/structural_bar'],
  initialize: function(options) {
    options = options || {};
    this._news = new Structural.Views.News();
  },

  render: function() {
    this.$el.html(this.template({user: this.model}));
    this.insertChildBefore(this._news, this.$('.stb-name'));
    return this;
  }
});
