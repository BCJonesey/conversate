Structural.Views.ParticipantEditor = Support.CompositeView.extend({
  className: 'act-participants btn-faint-container',
  template: JST['backbone/templates/participants/editor'],
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;
  },
  render: function() {
    var tokens = new Structural.Views.Participants({collection: this.participants});
    // TODO: Figure out the right way to wire the options view to the ever-changing
    // options collection and insert it in here.

    this.$el.html(this.template());
    this.prependChild(tokens);
    return this;
  },
  events: {
    'click .act-participants-edit': 'enterEditingMode',
    'click .act-participants-save': 'saveParticipants',
  },
  enterEditingMode: function(e) {
    // TODO: Enable edit mode on participants list.
  },
  saveParticipants: function(e) {
    // TODO: Save new list of participants.
  }
});
