Structural.Views.Participants = Support.CompositeView.extend({
  className: 'act-participants',
  initialize: function(options) {
    this._participants = options.participants;
    this._addressBook = options.addressBook;
  },
  render: function() {
    this._list = new Structural.Views.ParticipantList({
      collection: this._participants
    });
    this.appendChild(this._list);

    this._editor = new Structural.Views.ParticipantEditor({
      participants: this._participants,
      addressBook: this._addressBook
    });
    this.appendChild(this._editor);
    this._editor.on('update_users', this.updateUsers, this);
  },

  updateUsers: function(editedParticipants) {
    var added = Support.Collections.difference(editedParticipants, this._participants);
    var removed = Support.Collections.difference(this._participants, editedParticipants);

    if (added.length > 0 || removed.length > 0) {
      this.trigger('update_users', added, removed);
      this._list.replaceCollection(editedParticipants);
      this._participants = editedParticipants;
    }
  }
});
