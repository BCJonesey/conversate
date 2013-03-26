Structural.Views.ParticipantOption = Support.CompositeView.extend({
  tagName: 'li',
  className: 'token-option',
  initialize: function(options) {

  },
  render: function() {
    this.$el.text(this.model.escape('name'));
    return this;
  },
  events: {
    'click': 'selectOption'
  },
  selectOption: function(e) {
    // TODO: Select this option.
  }
});
