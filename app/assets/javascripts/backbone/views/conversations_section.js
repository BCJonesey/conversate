Structural.Views.ConversationsSection = Support.CompositeView.extend({
  className: 'cnv-section',
  initialize: function(options) {
    options = options || {};
    this.name = options.name;
  },
  template: JST['backbone/templates/conversations/conversations-section'],
  render: function() {
    this.$el.html(this.template({name: this.name}));
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
    $(e.target).closest('.cnv-section').toggleClass('is-collapsed')
  }
});
