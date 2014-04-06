Structural.Views.ConversationsSection = Support.CompositeView.extend({
  className: 'cnv-section',
  initialize: function(options) {
    options = options || {};
    this.name = options.name;
    this.adjective = options.adjective;
    this.collection = []
    this.startsCollapsed = options.startsCollapsed;
    this.user = options.user;
    this.predicate = options.predicate;
    this.priority = options.priority;
    this.viewOrder = options.viewOrder;
  },
  template: JST.template('conversations/conversations-section'),
  render: function() {
    if (this.collection.length > 0) {
      if (this.startsCollapsed) {
        this.$el.addClass('is-collapsed');
        // We don't want to automatically collapse the section if a
        // new conversation or something comes in.
        this.startsCollapsed = false;
      }
      this.$el.html(this.template({
        name: this.name,
        adjective: this.adjective,
        collection: this.collection
      }));
      this.delegateEvents();
      this.renderConversations(this.collection);
    }
    return this;
  },
  events: {
    'click .cnv-divider': 'toggleCollapsed',
    'click .cnv-note': 'toggleCollapsed'
  },
  renderConversation: function(conversation) {
    var view = new Structural.Views.Conversation({
      model: conversation,
      user: this.user
    });

    this.appendChild(view);
  },
  toggleCollapsed: function(e){
    var targetEl = this.$el;
    if (e) {
      targetEl = $(e.target).closest('.cnv-section');
    }
    targetEl.toggleClass('is-collapsed')
  },
  isCollapsed: function() {
    return this.$el.hasClass('is-collapsed');
  },
  renderConversations: function(conversations) {
    var self = this;
    conversations.forEach(function(conversation) {
      self.renderConversation(conversation);
    });
  },

  getFocusedView: function(conversation) {
    return this.childrenByModelClientId[conversation.cid];
  }
});
