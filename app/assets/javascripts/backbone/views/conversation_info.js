ConversateApp.Views.ConversationInfo = Backbone.View.extend({
  render: function () {
    console.log(this.options.conversation);
    this.$el.html(JST['backbone/templates/conversations/conversation-info']({ conversation: this.options.conversation }));
    return this;
  },
  initialize: function () {
        _.bindAll(this, 'render');
  }
});
