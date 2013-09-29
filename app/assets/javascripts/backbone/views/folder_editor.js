Structural.Views.FolderEditor = Support.CompositeView.extend({
  className: 'fld-editor',
  template: JST['backbone/templates/folders/editor'],
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
    'click .ef-save-button': 'save'
  },

  show: function(folder) {
    this._folder = folder;
    this.render(folder);
    this.$('.modal-background').removeClass('hidden');
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
  }
});
