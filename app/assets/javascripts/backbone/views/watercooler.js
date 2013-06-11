Structural.Views.WaterCooler = Support.CompositeView.extend({
  className: 'water-cooler',
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
    this.conversations = options.conversations;
    this.actions = options.actions;
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.topicsView = new Structural.Views.TopicContainer({
      topics: this.topics
    });
    this.conversationsView = new Structural.Views.ConversationContainer({
      conversations: this.conversations
    });
    this.actionsView = new Structural.Views.ActionContainer({
      actions: this.actions,
      conversation: this.conversation,
      participants: this.participants,
      addressBook: this.addressBook
    });

    this.appendChild(this.topicsView);
    this.appendChild(this.conversationsView);
    this.appendChild(this.actionsView);
  },

  changeConversation: function(conversation) {
    this.actionsView.changeConversation(conversation);
  },
  clearConversation: function() {
    this.actionsView.clearConversation();
  },
  moveConversationMode: function() {
    this.topicsView.moveConversationMode();
  }
});
