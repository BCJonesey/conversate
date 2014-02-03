Structural.Views.StructuralBar = Support.CompositeView.extend({
  className: 'structural-bar clearfix',
  template: JST.template('structural/structural_bar'),
  initialize: function(options) {
    options = options || {};
    this._news = new Structural.Views.News();
    this._search = new Structural.Views.Search();
  },

  render: function() {
    this.$el.html(this.template({user: this.model}));
    var nameEl = this.$('.stb-name');
    this.insertChildBefore(this._search, nameEl);
    this.insertChildBefore(this._news, nameEl);
    return this;
  }
});
