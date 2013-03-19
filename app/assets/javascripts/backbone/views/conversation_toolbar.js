Structural.Views.ConversationToolbar = Support.CompositeView.extend({
  className: 'btn-toolbar cnv-toolbar clearfix',
  render: function() {
    this.$el.html(JST['backbone/templates/conversations/toolbar']());
    return this;
  },
  events: {
    '.cnv-new-button': 'newConversation'
  },
  newConversation: function() {
    // TODO: Create a new conversation
  }
});
