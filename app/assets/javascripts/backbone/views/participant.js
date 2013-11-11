Structural.Views.Participant = Support.CompositeView.extend({
  tagName: 'span',
  className: function() {
    var classes = 'token participant';
    if (this.model.get('external')) {
      classes += ' user-external';
    }
    return classes;
  },
  template: JST['backbone/templates/participants/token'],
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template({participant: this.model}));
    this.reClass();
    return this;
  },
  reClass: function() {
    this.el.className = this.className();
  },
  events: {
    'click .participant-remove': 'removeParticipant'
  },
  removeParticipant: function(e) {
    this.trigger('remove', this);
  }
});
