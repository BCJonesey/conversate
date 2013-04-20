Structural.Views.Participants = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'tokens',
  inputElement: '<li class="token-input-wrap"><input type="text" readonly="readonly" class="token-input"></li>',
  userReminder: '<li class="user-reminder">You, and...</li>',
  initialize: function(options) {
    this.originalCollection = this.collection.clone();
  },
  render: function() {
    this.$el.append($(this.userReminder));
    this.$el.append($(this.inputElement));
    this.collection.each(this.renderParticipant, this);
    return this;
  },
  renderParticipant: function(participant) {
    var view = new Structural.Views.Participant({model: participant});
    view.on('remove', this.removeToken, this);
    this.insertChildBefore(view, this.$('.token-input-wrap'));
  },
  events: {
    'keyup .token-input': 'tokenInput',
    'keydown .token-input': 'preventSubmit'
  },

  edit: function() {
    this.$('.token-input').removeAttr('readonly');
    this.focus();
  },
  save: function() {
    var added   = this._difference(this.collection, this.originalCollection);
    var removed = this._difference(this.originalCollection, this.collection);
    Structural.createUpdateUserAction(added, removed);
    this.originalCollection = this.collection.clone();
    this.$('.token-input').attr('readonly', 'readonly');
  },
  cancel: function() {
    this.collection = this.originalCollection;
    this.$el.empty();
    this.render();
    this.$('.token-input').attr('readonly', 'readonly');
  },
  focus: function() {
    this.$('.token-input').focus();
  },
  tokenInput: function(e) {
    if (e.which === 38) { // Up
      this.trigger('moveAutocompleteTarget', 'up');
    } else if (e.which === 40) { // Down
      this.trigger('moveAutocompleteTarget', 'down');
    } else if (e.which === 13 || // Enter
               e.which === 9) {  // Tab
      this.trigger('selectAutocompleteTarget');
    } else {
      this.trigger('changeAutocompleteOptions', this.$('.token-input').val())
    }
  },
  preventSubmit: function(e) {
    if (e.which === 13) { // Enter
      e.preventDefault();
    }
  },
  addToken: function(participant) {
    this.renderParticipant(participant);
    this.collection.add(participant);
    this.$('.token-input').val('');
  },
  removeToken: function(participant) {
    participant.leave();
    this.collection.remove(participant.model);
    this.focus();
  },

  // This should be identical to _.difference, but I can't get that to work
  // for me.  It keeps giving me garbage or not existing, depending on how
  // I call it.
  _difference: function(a, b) {
    return a.reject(function(x) {
      return b.contains(x);
    });
  }
});
