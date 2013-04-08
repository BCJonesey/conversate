Structural.Views.TitleEditor = Support.CompositeView.extend({
  className: 'btn-toolbar act-title btn-faint-container',
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
    e.preventDefault();
    this.conversation.changeTitle(this.$('input').val());
    this.closeTitleEditor();
  },
  moveConversation: function(e) {
    // TODO: Enter move conversation mode.  This has to affect the topics view.
    e.preventDefault();
  },
  openTitleEditor: function(e) {
    e.preventDefault();
    this.$('.act-title-actions').addClass('hidden');
    this.$('.act-title-save-actions').removeClass('hidden');
    this.$('input[type="text"]').removeAttr('readonly');
    this.$('input[type="text"]').focus();

    Structural.on('clickAnywhere', this.closeTitleEditor, this);
  },
  closeTitleEditor: function(e) {
    if ($(e.target).closest('.act-title').length == 0) {
      this.$('.act-title-actions').removeClass('hidden');
      this.$('.act-title-save-actions').addClass('hidden');
      this.$('input[type="text"]').attr('readonly', 'readonly');

      Structural.off('clickAnywhere', this.closeTitleEditor, this);
    }
  }
});
