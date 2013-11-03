Structural.Views.ConversationsSection = Support.CompositeView.extend({
  initialize: function(options) {
    options = options || {};
    this.name = options.name;
  },
  template: JST['backbone/templates/conversations/conversations-section'],
  render: function() {
    this.$el.html(this.template({name: this.name}));
    return this;
  },
  renderConversation: function(conversation) {
    var view = new Structural.Views.Conversation({
      model: conversation,
      user: this.user
    });
    this.appendChild(view);
  }
});
