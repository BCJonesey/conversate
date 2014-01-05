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
  }
});
