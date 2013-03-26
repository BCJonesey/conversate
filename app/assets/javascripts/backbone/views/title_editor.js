Structural.Views.TitleEditor = Support.CompositeView.extend({
  className: 'act-title btn-faint-container',
  template: JST['backbone/templates/actions/title_editor'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
  },
  render: function() {
    this.$el.html(this.template({conversation: this.conversation}));
    return this;
  },
  events: {
    submit: 'retitleConversation',
    'click .act-move-cnv': 'moveConversation',
    'click .act-title-edit': 'openTitleEditor',
    'click .act-title-save': 'retitleConversation'
  },
  retitleConversation: function(e) {
    // TODO: Close title editor, change conversation title.
  },
  moveConversation: function(e) {
    // TODO: Enter move conversation mode.  This has to affect the topics view.
  },
  openTitleEditor: function(e) {
    // TODO: Make title input editable, show save button.
  }
});
