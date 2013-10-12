Structural.Views.StructuralBar = Support.CompositeView.extend({
  className: 'structural-bar clearfix',
  template: JST['backbone/templates/structural/structural_bar'],
  initialize: function(options) {
    options = options || {};
  },

  events: {
    'click .wc-news-toggle': 'toggleNews'
  },

  toggleNews: function(){
    $(".wc-news-popover").toggleClass('hidden');
  },

  render: function() {
    this.$el.html(this.template({user: this.model}));
    return this;
  }
});
