Structural.Views.StructuralBar = Support.CompositeView.extend({
  className: 'structural-bar clearfix',
  template: JST.template('structural/structural_bar'),
  initialize: function(options) {
    options = options || {};
    this._news = new Structural.Views.News();
    this._search = new Structural.Views.Search();

    this.listenTo(Structural.Router, 'route', this._updateButtonSelection);
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
  },
  _updateButtonSelection: function(routeName) {
    if (_.contains(['index', 'conversation', 'folder'], routeName)) {
      this.$('.stb-link-watercooler').addClass('stb-selected');
      this.$('.stb-link-people').removeClass('stb-selected');
    } else if (routeName === 'people') {
      this.$('.stb-link-watercooler').removeClass('stb-selected');
      this.$('.stb-link-people').addClass('stb-selected');
    }
  }
});
