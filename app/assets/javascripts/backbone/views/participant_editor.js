Structural.Views.ParticipantEditor = Support.CompositeView.extend({
  className: 'btn-group act-participants-editor',
  template: JST.template('participants/editor'),
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;

    Structural.on('clickAnywhere', this.saveAndCloseIfClickOff, this);
    Structural.on('changeConversation', this.changeConversation, this);
    Structural.on('clearConversation', this.clearConversation, this);
  },
  render: function() {
    this.$el.html(this.template());

    this.autocomplete = new Structural.Views.Autocomplete({
      dictionary: Structural._user.addressBook(),
      blacklist: this.participants.clone(),
      addSelectionToBlacklist: true,
      property: 'name'
    });
    this.removableList = new Structural.Views.RemovableParticipantList({
      collection: this.participants.clone(),
    });

    this.autocomplete.on('select', this.removableList.add, this.removableList);
    this.removableList.on('remove', this.autocomplete.removeFromBlacklist, this.autocomplete);
    this.listenTo(Structural._user, 'addressBookUpdated', this._updateAddressBook);

    this.renderChildInto(this.autocomplete, this.$('.act-participants-editor-autocomplete'));
    this.renderChildInto(this.removableList, this.$('.act-participants-editor-list'));

    return this;
  },
  events: {
    'click .act-participants-edit': 'toggleEditor',
    'click .act-participants-editor-popover .popover-close': 'toggleEditor',
    'click .act-participants-join': 'joinConversation',
    'click .act-participants-save': 'saveAndClose'
  },

  toggleEditor: function(e) {
    if (e) { e.preventDefault(); }

    this.$('.act-participants-editor-popover').toggleClass('hidden');
    this.$('.act-participants-edit').toggleClass('active');
  },
  joinConversation: function(e) {
    if (e) { e.preventDefault(); }

    Structural.addSelfToConversation();
  },
  saveAndClose: function(e) {
    if (e) { e.preventDefault(); }

    var editedParticipants = this.removableList.participants();
    this.trigger('update_users', editedParticipants);
    this.participants = editedParticipants;

    this.toggleEditor();
  },
  saveAndCloseIfClickOff: function(e) {
    var target = $(e.target);
    if (target.closest('.act-participants-editor').length === 0 &&
        target.closest('body').length !== 0 &&
        this._isOpen()) {
      this.saveAndClose();
    }
  },

  changeConversation: function(conversation) {
    this._replaceParticipants(conversation.get('participants'));
  },
  clearConversation: function() {
    this._replaceParticipants(new Structural.Collections.Participants([]));
  },
  _updateAddressBook: function(){
    this.autocomplete.replaceDictionary(Structural._user.addressBook());
  },
  _isOpen: function() {
    return !this.$('.act-participants-editor-popover').hasClass('hidden');
  },
  _replaceParticipants: function(participants) {
    this.autocomplete.replaceBlacklist(participants);
    this.removableList.replace(participants);
  }
});
