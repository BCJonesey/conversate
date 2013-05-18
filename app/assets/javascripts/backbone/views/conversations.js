Structural.Views.Conversations = Support.CompositeView.extend({
  className: 'cnv-list',
  initialize: function(options) {
    this.collection.on('add', this.renderConversation, this);
    this.collection.on('reset', this.reRender, this);
  },
  render: function() {
    this.collection.forEach(this.renderConversation, this);
    return this;
  },
  renderConversation: function(conversation) {
    var view = new Structural.Views.Conversation({model: conversation});
    this.appendChild(view);
  },
  reRender: function() {
    this.children.forEach(function(child) {
      child.leave();
    });
    this.render();
  }
});

