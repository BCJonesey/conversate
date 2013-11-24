Structural.Views.TitleEditor = Support.CompositeView.extend({
  className: 'btn-toolbar act-title',
  template: JST['backbone/templates/actions/title_editor'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
    this.folders = options.folders;
    Structural.on('changeConversation', this.changeConversation, this);
    Structural.on('clearConversation', this.clearConversation, this);
    Structural.on('clickAnywhere', this.hide, this);
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
    'click .act-title-edit': 'toggleTitleEditor',
    'click .act-title-editor-popover .popover-close': 'toggleTitleEditor',
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
    this.render();
  },
  toggleUpdateFoldersDialog: function(e) {
    e.preventDefault();
    this._updateFoldersDialog.toggleVisible();
  },
  toggleTitleEditor: function(e) {
    e.preventDefault();
    // TODO: Really move the title editor out into its own view? The current span wrapping makes it a little
    // tricky...
    this.$('.act-title-editor-popover').toggleClass('hidden');
    this.$('.act-title-editor-toggle').toggleClass('active');
  },
  isOpen: function() {
    return !this.$('.act-title-editor-popover').hasClass('hidden');
  },
  hide: function(e) {
    var target = $(e.target);
    if (target.closest('.act-title-editor-wrap').length === 0 && this.isOpen()) {
      this.toggleTitleEditor(e);
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
