Structural.Views.WaterCooler = Support.CompositeView.extend({
  className: 'water-cooler',
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
    this.conversations = options.conversations;
    this.actions = options.actions;
    this.conversation = options.conversation;
    this.participants = options.participants;
  },
  render: function() {
    var topics = new Structural.Views.TopicContainer({
      topics: this.topics
    });
    var conversations = new Structural.Views.ConversationContainer({
      conversations: this.conversations
    });
    var actions = new Structural.Views.ActionContainer({
      actions: this.actions,
      conversation: this.conversation,
      participants: this.participants
    });

    this.appendChild(topics);
    this.appendChild(conversations);
    this.appendChild(actions);
  }
});
