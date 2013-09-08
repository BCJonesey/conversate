// A view for the actual conversations list.

Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list',
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this.collection.on('add', this.reRender, this);
    this.collection.on('reset', this.reRender, this);

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

    // We should show the first conversation if available, as well.
    var conversation = this.collection.models[0];
    if (conversation) {
      Structural.viewConversation(conversation);
    }

    this.reRender();
  }
});

