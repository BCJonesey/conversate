ConversateApp.Views.ConversationInfo = Backbone.View.extend({
  render: function () {
    this.$el.html(JST['backbone/templates/conversations/conversation-info'](
      {
        conversation: this.options.conversation,
        helpers: this.helpers
      }));
    return this;
  },
  initialize: function () {
        _.bindAll(this, 'render');
  },
  helpers: {
    // TODO DRY with messages_index view.
    name: function (name) {
      return name.full_name || name.email;
    }
  }
});
