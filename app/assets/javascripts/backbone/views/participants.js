Structural.Views.Participants = Support.CompositeView.extend({
  className: 'act-participants',
  initialize: function(options) {
    this._participants = options.participants;
    this._addressBook = options.addressBook;
  },
  render: function() {
    this.appendChild(new Structural.Views.ParticipantList({
      collection: this._participants
    }));

    var editor = new Structural.Views.ParticipantEditor({
      participants: this._participants,
      addressBook: this._addressBook
    });
    this.appendChild(editor);
    editor.on('update_users', function(added, removed) {
      this.trigger('update_users', added, removed);
    }, this);
  }
});
