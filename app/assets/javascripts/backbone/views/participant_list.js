Structural.Views.ParticipantList = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'act-participants-list',
  template: JST.template('participants/list'),
  initialize: function(options) {
    this.listenTo(Structural, 'changeConversation', this.changeConversation, this);
    this.listenTo(Structural, 'clearConversation', this.clearConversation, this);
  },
  render: function() {
    this.$el.html(this.template({participants: this.collection}));
    return this;
  },

  changeConversation: function(conversation) {
    this.replaceCollection(conversation.get('participants'));
  },
  clearConversation: function() {
    this.replaceCollection(new Structural.Collections.Participants([]));
  },

  replaceCollection: function(collection) {
    this.collection = collection;
    this.render();
  }
});
