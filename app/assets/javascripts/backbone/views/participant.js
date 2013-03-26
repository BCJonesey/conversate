Structural.Views.Participant = Support.CompositeView.extend({
  tagName: 'li',
  className: 'token participant',
  template: JST['backbone/templates/participants/token'],
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template({participant: this.model}));
    return this;
  },
  events: {
    'click .participant-remove': 'removeParticipant'
  },
  removeParticipant: function(e) {
    // TODO: Remove participant.
  }
});
