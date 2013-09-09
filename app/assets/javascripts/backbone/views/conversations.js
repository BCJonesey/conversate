// A view for the actual conversations list.

Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list',
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this.collection.on('add', this.reRender, this);
    this.collection.on('reset', this.reRender, this);
    this.collection.on('conversationsLoadedForFirstTime', this.viewFirstConversation, this);

    Structural.on('changeTopic', this.changeTopic, this);
  },
  render: function() {
    this.$el.empty();
    this.collection.forEach(this.renderConversation, this);
    return this;
  },
  renderConversation: function(conversation) {
    var view = new Structural.Views.Conversation({
      model: conversation,
      user: this.user
    });
    this.appendChild(view);
  },
  reRender: function() {
    this.children.forEach(function(child) {
      child.leave();
    });
    this.render();
  },
  changeTopic: function(topic) {
    this.collection.off(null, null, this);
    this.collection = topic.conversations;
    this.collection.on('add', this.renderConversation, this);
    this.collection.on('reset', this.reRender, this);
    this.collection.on('conversationsLoadedForFirstTime', this.viewFirstConversation, this);

    // Attempt to show the first conversation. This gets called always, so will pick up on cached
    // conversations just fine. However, the conversationsLoadedForFirstTime event will pick up
    // on conversations that needed fetching for picking the first.
    this.viewFirstConversation();

    this.reRender();
  },

  // Attempts to show the first conversation. This basically gets called after the conversations
  // have finished loading, so we can actually pick one to show.
  viewFirstConversation: function() {
    var conversation = this.collection.models[0];
    if (conversation) {
      Structural.viewConversationData(conversation);
    }
  }
});

