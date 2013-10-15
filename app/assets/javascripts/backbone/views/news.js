Structural.Views.News = Support.CompositeView.extend({
  tagName: 'span',
  className: 'wc-news-wrap popover-wrap',
  template: JST['backbone/templates/structural/news'],
  initialize: function(options) {
    Structural.on('clickAnywhere', this.hide, this);
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .wc-news-toggle': 'toggleNews'
  },

  isOpen: function() {
    return !this.$('.wc-news-popover').hasClass('hidden');
  },
  toggleNews: function() {
    this.$('.wc-news-popover').toggleClass('hidden');
  },
  hide: function(e) {
    var target = $(e.target);
    if (target.closest('.wc-news-wrap').length === 0 && this.isOpen()) {
      this.toggleNews();
    }
  }
});
