Structural.Views.News = Support.CompositeView.extend({
  tagName: 'span',
  className: 'popover-wrap',
  template: JST['backbone/templates/structural/news'],
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'click .wc-news-toggle': 'toggleNews'
  },

  toggleNews: function() {
    $('.wc-news-popover').toggleClass('hidden');
  }
});
