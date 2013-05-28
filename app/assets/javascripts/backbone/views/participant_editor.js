Structural.Views.ParticipantEditor = Support.CompositeView.extend({
  className: 'act-participants btn-faint-container',
  template: JST['backbone/templates/participants/editor'],
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;
    this.addressBook = options.addressBook;

    this.tokens = new Structural.Views.Participants({collection: this.participants});
    this.tokenOptions = new Structural.Views.AutocompleteOptions({collection: this.addressBook});
    this.tokens.on('moveAutocompleteTarget', this.tokenOptions.moveAutocompleteTarget, this.tokenOptions);
    this.tokens.on('changeAutocompleteOptions', this.tokenOptions.changeAutocompleteOptions, this.tokenOptions);
    this.tokens.on('selectAutocompleteTarget', this.selectParticipant, this);
    this.tokenOptions.on('selectAutocompleteTarget', this.selectParticipant, this);
    this.tokens.on('update_users', function(added, removed) {
      this.trigger('update_users', added, removed);
    }, this);

    this.participants.on('reset', this.reRender, this);
  },
  render: function() {
    this.$el.html(this.template());
    this.prependChild(this.tokens);
    this.appendChildTo(this.tokenOptions, this.$('.token-input-wrap'));
    return this;
  },
  reRender: function() {
    this.tokens.leave();
    this.tokenOptions.leave();
    this.$el.empty();
    this.render();
  },
  events: {
    'click .act-participants-edit': 'enterEditingMode',
    'click .act-participants-save': 'saveParticipants',
  },
  enterEditingMode: function(e) {
    if (e) { e.preventDefault(); }
    this.$('.act-participants-actions, .act-participants-save-actions')
      .toggleClass('hidden');
    this.tokens.edit();
    this.$el.addClass('editing');

    Structural.on('clickAnywhere', this.cancel, this);
  },
  saveParticipants: function(e) {
    e.preventDefault();
    this.$('.act-participants-actions, .act-participants-save-actions')
      .toggleClass('hidden');
    this.tokens.save();
    this.$el.removeClass('editing');

    Structural.off('clickAnywhere', this.cancel, this);
  },
  selectParticipant: function() {
    this.tokens.addToken(this.tokenOptions.currentOption());
    this.tokenOptions.clear();
    this.tokens.focus();
  },
  cancel: function(e) {
    if (!e || ($(e.target).closest('.act-participants').length === 0 &&
               $(e.target).closest('body').length > 0)) {
      this.tokens.cancel();
      this.$el.removeClass('editing');
      this.$('.act-participants-actions, .act-participants-save-actions')
        .toggleClass('hidden');

      Structural.off('clickAnywhere', this.cancel, this);
    }
  },
  currentParticipants: function() {
    return this.tokens.currentParticipants();
  }
});
