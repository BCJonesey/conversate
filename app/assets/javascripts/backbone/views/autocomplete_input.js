Structural.Views.AutocompleteInput = Support.CompositeView.extend({
  className: '',
  template: JST['backbone/templates/autocomplete/input'],
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  events: {
    'keyup': 'input',
    'keydown': 'preventSubmit'
  },


});
