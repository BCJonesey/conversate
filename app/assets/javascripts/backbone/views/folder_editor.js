Structural.Views.FolderEditor = Support.CompositeView.extend({
  className: 'fld-editor',
  template: JST.template('folders/editor'),
  initialize: function(options) {
    options = options || {};
    this._user = options.user;
  },
  render: function() {
    if (this._folder) {
      this.$el.html(this.template({folder: this._folder, user: this._user}));

      if (this._folder.isShared()) {
        this._autocomplete = new Structural.Views.Autocomplete({
          dictionary: Structural._user.addressBook(),
          blacklist: this._folder.get('users').clone(),
          addSelectionToBlacklist: true,
          property: 'name'
        });
        this._removableList = new Structural.Views.RemovableParticipantList({
          collection: this._folder.get('users').clone()
        });

        this._autocomplete.on('select', this._removableList.add, this._removableList);
        this._removableList.on('remove', this._autocomplete.removeFromBlacklist, this._autocomplete);
        this.listenTo(Structural._user, 'addressBookUpdated', this._updateAddressBook);

        this.insertChildAfter(this._removableList, this.$('label[for="folder-participants"]'));
        this.insertChildAfter(this._autocomplete, this.$('label[for="folder-participants"]'));
      }
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
    this.render();
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
      var email = null;
      if(this._user.get('site_admin')){
        email = this.$('.ef-email-input').val();
      }
      if (name.length === 0) { return; }

      var participants = this._removableList.participants();

      this._folder.update(name, participants, email);
      this.$('.modal-background').addClass('hidden');
    }
  },
  delete: function(e) {
    e.preventDefault();
    if (this._folder) {
      Structural.deleteFolder(this._folder);
      this.$('.modal-background').addClass('hidden');
    }
  },
  _updateAddressBook: function(){
    this._autocomplete.replaceDictionary(Structural._user.addressBook());
  }
});
