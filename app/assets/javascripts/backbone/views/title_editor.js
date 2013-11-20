Structural.Views.TitleEditor = Support.CompositeView.extend({
  className: 'btn-toolbar act-title',
  template: JST['backbone/templates/actions/title_editor'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
    this.folders = options.folders;
    Structural.on('changeConversation', this.changeConversation, this);
    Structural.on('clearConversation', this.clearConversation, this);
  },
  render: function() {
    this.$el.html(this.template({conversation: this.conversation}));
    this._updateFoldersDialog = new Structural.Views.UpdateFoldersDialog({
      folders: this.folders,
      conversation: this.conversation
    });
    this.appendChild(this._updateFoldersDialog);
    this._input = this.$('input[type="text"]');
    return this;
  },
  events: {
    submit: 'retitleConversation',
    'click .act-move-cnv': 'toggleUpdateFoldersDialog',
    'click .act-title-edit': 'openTitleEditor',
    'click .act-title-save': 'retitleConversation',
    'click .act-archive-cnv': 'archiveConversation',
    'keyup': 'cancelOnEscape'
  },
  retitleConversation: function(e) {
    e.preventDefault();
    var title = this.$('input').val().trim();

    if (title === this.conversation.get('title').trim()) {
      this.cancelRetitle();
      return;
    }

    this.conversation.changeTitle(title);
    this.trigger('change_title', title);
    this.closeTitleEditor();
  },
  archiveConversation: function(e) {
    e.preventDefault();
    this.conversation.toggleArchive();
  },
  toggleUpdateFoldersDialog: function(e) {
    e.preventDefault();
    this._updateFoldersDialog.toggleVisible();
  },
  openTitleEditor: function(e) {
    e.preventDefault();
    // TODO: Really move the title editor out into its own view? The current span wrapping makes it a little
    // tricky...
    this.$('.wc-title-editor-popover').toggleClass('hidden');
    this.$('.wc-title-editor-toggle').toggleClass('active');
  },
  closeTitleEditor: function(e) {
    if (!e || $(e.target).closest('.act-title').length === 0) {
      this.$('.act-title-actions').removeClass('hidden');
      this.$('.act-title-save-actions').addClass('hidden');
      this.$el.removeClass('editing');
      this.$('input[type="text"]').attr('readonly', 'readonly');

      Structural.off('clickAnywhere', this.closeTitleEditor, this);
      return true;
    }
    return false;
  },
  cancelRetitle: function(e) {
    if(this.closeTitleEditor(e)) {
      this.$('input[type="text"]').val(this.conversation.get('title'));
    }
  },
  cancelOnEscape: function(e) {
    if (e.which === Support.Keys.escape) {
      this.cancelRetitle();
    }
  },
  changeConversation: function(conversation) {
    this.conversation = conversation;
    this.$el.empty();
    this.render();
  },
  clearConversation: function() {
    this.conversation = undefined;
    this.$el.empty();
  }
});
