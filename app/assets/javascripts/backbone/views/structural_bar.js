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
    this.insertChildAfter(this._search, nameEl);
    this.insertChildBefore(this._news, nameEl);
    return this;
  },

  events: {
    'click .stb-link-watercooler': 'navigateToWaterCooler',
    'click .stb-link-people': 'navigateToPeople'
  },

  navigateToWaterCooler: function(e) {
    e.preventDefault();
    this._navigateTo(Structural.Router.indexPath());
  },
  navigateToPeople: function(e) {
    e.preventDefault();
    this._navigateTo(Structural.Router.peoplePath());
  },

  _navigateTo: function(path) {
    Structural.Router.navigate(path, {trigger: true});
  }
});
