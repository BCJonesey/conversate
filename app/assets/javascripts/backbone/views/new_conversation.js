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
      collection: this.participants.clone()
    });

    this.autocomplete.on('select', this.removableList.add, this.removableList);
    this.removableList.on('remove', this.autocomplete.removeFromBlacklist, this.autocomplete);

    this.$el.html(this.template());
    this.insertChildBefore(this.removableList, this.$('.new-cnv-contents'));
    this.insertChildBefore(this.autocomplete, this.$('.new-cnv-contents'));

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
    var participants = this.removableList.participants();
    var firstMessage = this.$('.new-cnv-body').val();

    Structural.createNewConversation(title, participants, firstMessage);
    this.leave();
  }
});
