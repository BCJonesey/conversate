Structural.Views.ConversationToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar cnv-toolbar clearfix',
  template: JST['backbone/templates/conversations/toolbar'],
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    '.cnv-new-button': 'newConversation'
  },
  newConversation: function() {
    // TODO: Create a new conversation
  }
});
