Structural.Views.FolderEditor = Support.CompositeView.extend({
  className: 'fld-editor',
  template: JST.template('folders/editor'),
  initialize: function(options) {
    options = options || {};
    this._addressBook = options.addressBook;
  },
  render: function(folder) {
    if (folder) {
      this._participantEditor = new Structural.Views.ParticipantEditor({
        participants: folder.get('users'),
        addressBook: this._addressBook
      });

      this.$el.html(this.template({folder: folder}));
      this.insertChildAfter(this._participantEditor, this.$('label[for="folder-participants"]'));
    }
    return this;
  },

  events: {
    'click .ef-save-button': 'save',
    'click .ef-delete-button':'delete',
    'click .ef-trash-button':'showDeleteWarning',
    'click .ef-deletion-cancel':'hideDeleteWarning',
    'click .ef-deletion-confirmation':'toggleDeleteButton'
  },

  show: function(folder) {
    this._folder = folder;
    this.render(folder);
    this.$('.modal-background').removeClass('hidden');
  },
  showDeleteWarning: function(e){
    e.preventDefault();
    this.$('.ef-window-content').addClass('hidden');
    this.$('.ef-deletion-content').removeClass('hidden');
  },
  hideDeleteWarning: function(e){
    e.preventDefault();
    this.$('.ef-window-content').removeClass('hidden');
    this.$('.ef-deletion-content').addClass('hidden');
    this.hideDeleteButton();
    this.$('.ef-deletion-confirmation').prop('checked', false);
  },
  showDeleteButton: function(e){
    this.$('.ef-delete-button').removeClass('hidden');
    this.$('.ef-save-button').addClass('hidden');
  },
  hideDeleteButton: function(e){
    this.$('.ef-save-button').removeClass('hidden');
    this.$('.ef-delete-button').addClass('hidden');
  },
  toggleDeleteButton: function(e){
    if (this.$('.ef-deletion-confirmation').prop('checked') === true){
      this.showDeleteButton();
    } else {
      this.hideDeleteButton();
    }
  },
  save: function(e) {
    e.preventDefault();
    if (this._folder) {
      var name = this.$('.ef-name-input').val();
      if (name.length === 0) { return; }

      var participants = this._participantEditor.currentParticipants();

      this._folder.update(name, participants);
      this.$('.modal-background').addClass('hidden');
    }
  },
  delete: function(e) {
    e.preventDefault();
    if (this._folder) {
      Structural.deleteFolder(this._folder);
      this.$('.modal-background').addClass('hidden');
    }
  }
});
