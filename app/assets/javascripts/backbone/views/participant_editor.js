Structural.Views.ParticipantEditor = Support.CompositeView.extend({
  className: 'btn-group act-participants-editor',
  template: JST.template('participants/editor'),
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;
    this.addressBook = options.addressBook;
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
});
