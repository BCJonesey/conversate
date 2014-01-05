Structural.Views.NewConversation = Support.CompositeView.extend({
  className: 'new-cnv-compose',
  template: JST.template('conversations/new'),
  initialize: function(options) {
    options = options || {};
    this.participants = new Structural.Collections.Participants([]);
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.autocomplete = new Structural.Views.Autocomplete({
      dictionary: this.addressBook,
      blacklist: this.participants.clone(),
      addSelectionToBlacklist: true,
      property: 'name'
    });
    this.removableList = new Structural.Views.RemovableParticipantList({
      collection: this.participants.clone(),
      addAtEnd: true
    });

    this.autocomplete.on('select', this.removableList.add, this.removableList);
    this.removableList.on('remove', this.autocomplete.removeFromBlacklist, this.autocomplete);

    this.$el.html(this.template());
    this.appendChildTo(this.removableList, this.$('.new-cnv-participants'));
    this.appendChildTo(this.autocomplete, this.$('.new-cnv-participants'));

    return this;
  },
  events: {
    'click .disable-new-cnv': 'cancel',
    'click .send-new-cnv': 'send',
    'focus .new-cnv-participants input': 'enterParticipantEditingMode',
    'blur .new-cnv-participants input': 'leaveParticipantEditingMode',
    'focus .new-cnv-title-toolbar input': 'enterTitleEditingMode',
    'blur .new-cnv-title-toolbar input': 'leaveTitleEditingMode'
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
    var participants = this.removableList.participants();
    var firstMessage = this.$('.new-cnv-body').val();

    Structural.createNewConversation(title, participants, firstMessage);
    this.leave();
  },

  enterParticipantEditingMode: function(e) {
    this.$('.new-cnv-participants').addClass('editing');
  },
  leaveParticipantEditingMode: function(e) {
    this.$('.new-cnv-participants').removeClass('editing');
  },
  enterTitleEditingMode: function(e) {
    this.$('.new-cnv-title-toolbar').addClass('editing');
  },
  leaveTitleEditingMode: function(e) {
    this.$('.new-cnv-title-toolbar').removeClass('editing');
  }
});
