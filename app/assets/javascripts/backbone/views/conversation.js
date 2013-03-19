Structural.Views.Conversation = Support.CompositeView.extend({
  className: 'cnv',
  template: JST['backbone/templates/conversations/conversation'],
  initialize: function(options) {
    if (this.model.is_unread) {
      this.className += ' cnv-unread';
    }

    if (this.model.is_current) {
      this.className += ' cnv-current';
    }
  },
  render: function() {
    this.$el.html(this.template({conversation: this.model}));
    return this;
  }
});
