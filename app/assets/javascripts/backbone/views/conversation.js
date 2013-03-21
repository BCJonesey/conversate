Structural.Views.Conversation = Support.CompositeView.extend({
  className: function() {
    var classes = 'cnv';
    if (this.model.is_unread) {
      classes += ' cnv-unread';
    }

    if (this.model.is_current) {
      classes += ' cnv-current';
    }
    return classes;
  },
  template: JST['backbone/templates/conversations/conversation'],
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template({conversation: this.model}));
    return this;
  }
});
