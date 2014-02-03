Structural.Views.Search = Support.CompositeView.extend({
  tagName: 'span',
  className: 'search-wrap popover-wrap',
  template: JST.template('search/search'),
  initialize: function(options) {
    Structural.on('clickAnywhere', this.hide, this);
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .search-toggle': 'toggleSearch'
  },

  toggleSearch: function() {
    this.$('.search-popover').toggleClass('hidden');
    this.$('.search-toggle').toggleClass('active');
  },
  isOpen: function() {
    return !this.$('.search-popover').hasClass('hidden');
  },
  hide: function(e) {
    var target = $(e.target);
    if (target.closest('.search-wrap').length === 0 && this.isOpen()) {
      this.toggleSearch();
    }
  }
});
