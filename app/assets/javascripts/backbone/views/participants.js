Structural.Views.Participants = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'tokens',
  inputElement: '<li class="token-input-wrap"><input type="text" class="token-input"></li>',
  userReminder: '<li class="user-reminder">You, and...</li>',
  initialize: function() {
  },
  render: function() {
    this.$el.append($(this.userReminder));
    this.collection.each(this.renderParticipant, this);
    this.$el.append($(this.inputElement));
    return this;
  },
  renderParticipant: function(participant) {
    var view = new Structural.Views.Participant({model: participant});
    this.appendChild(view);
  },
  events: {
    'keyup .token-input': 'tokenInput',
    'keydown .token-input': 'preventSubmit'
  },
  tokenInput: function(e) {
    // TOOD: Handle token input.
  },
  preventSubmit: function(e) {
    // TODO: Prevent enter from submitting.
  }
});
