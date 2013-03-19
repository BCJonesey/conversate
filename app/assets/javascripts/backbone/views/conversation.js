Structural.Views.Conversation = Support.CompositeView.extend({
  className: 'cnv',
  template: JST['backbone/templates/conversations/conversation'],
  initialize: function(options) {
    if (this.model.attributes.most_recent_message > this.model.attributes.most_recent_viewed) {
      this.className += ' cnv-unread';
    }

    // TODO: Figure out how we're storing current conversation, update class.
  },
  render: function() {
    this.$el.html(this.template({conversation: this.model}));
    return this;
  }
});
