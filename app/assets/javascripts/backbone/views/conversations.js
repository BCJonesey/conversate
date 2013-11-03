// A view for the actual conversations list.

Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list',
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this._wireEvents(this.collection);

    Structural.on('changeFolder', this.changeFolder, this);
  },
  _wireEvents: function(collection) {
    collection.on('add', this.reRender, this);
    collection.on('reset', this.reRender, this);
    collection.on('remove', this.reRender, this);
    collection.on('conversationsLoadedForFirstTime', this.viewFirstConversation, this);
  },
  render: function() {
    this.$el.empty();
    var sectionRegular = new Structural.Views.ConversationsSection({name: "My Conversations"});
    this.appendChild(sectionRegular);

    var sectionArchived = new Structural.Views.ConversationsSection({name: "Archived"});
    this.appendChild(sectionArchived);
    //this.collection.forEach(this.renderConversation, this);
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
  changeFolder: function(folder) {
    this.collection.off(null, null, this);
    this.collection = folder.conversations;
    this._wireEvents(this.collection);

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
      conversation.focus();
    }
  }
});

