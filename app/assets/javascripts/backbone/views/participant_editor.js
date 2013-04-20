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
  },
  render: function() {
    this.$el.html(this.template());
    this.prependChild(this.tokens);
    this.appendChild(this.tokenOptions);
    return this;
  },
  events: {
    'click .act-participants-edit': 'enterEditingMode',
    'click .act-participants-save': 'saveParticipants',
  },
  enterEditingMode: function(e) {
    e.preventDefault();
    this.$('.act-participants-actions, .act-participants-save-actions')
      .toggleClass('hidden');
    this.tokens.edit();
    this.$el.addClass('editing');
  },
  saveParticipants: function(e) {
    e.preventDefault();
    this.$('.act-participants-actions, .act-participants-save-actions')
      .toggleClass('hidden');
    this.tokens.save();
    this.$el.removeClass('editing');
  },
  selectParticipant: function() {
    this.tokens.addToken(this.tokenOptions.currentOption());
    this.tokenOptions.clear();
    this.tokens.focus();
  }
});
