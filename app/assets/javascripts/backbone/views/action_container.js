Structural.Views.ActionContainer = Support.CompositeView.extend({
  className: 'act-container',
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
    this.participants = options.participants;
    this.actions = options.actions;
    this.addressBook = options.addressBook;
  },
  render: function() {
    var title = new Structural.Views.TitleEditor({conversation: this.conversation});
    var participants = new Structural.Views.ParticipantEditor({
      participants: this.participants,
      addressBook: this.addressBook
    });
    var actions = new Structural.Views.Actions({collection: this.actions});
    var compose = new Structural.Views.Compose({conversation: this.conversation});

    this.appendChild(title);
    this.appendChild(participants);
    this.appendChild(actions);
    this.appendChild(compose);

    return this;
  }
});
