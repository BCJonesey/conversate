Structural.Views.NewConversation = Support.CompositeView.extend({
  className: 'new-cnv-compose',
  template: JST.template('conversations/new'),
  initialize: function(options) {
    options = options || {};
    this.participants = new Structural.Collections.Participants([]);
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.participantEditor = new Structural.Views.ParticipantEditor({
      participants: this.participants,
      addressBook: this.addressBook
    });

    this.$el.html(this.template());
    this.insertChildBefore(this.participantEditor, this.$('.new-cnv-contents'));

    return this;
  },
  events: {
    'click .disable-new-cnv': 'cancel',
    'click .send-new-cnv': 'send'
  },

  cancel: function(e) {
    e.preventDefault();
    this.leave();
  },
  send: function(e) {
    e.preventDefault();

    var title = this.$('.new-cnv-title-input').val();
    if (title.length === 0) {
      title = 'New Conversation';
    }
    var participants = this.participantEditor.currentParticipants();
    var firstMessage = this.$('.new-cnv-body').val();

    Structural.createNewConversation(title, participants, firstMessage);
    this.leave();
  }
});
