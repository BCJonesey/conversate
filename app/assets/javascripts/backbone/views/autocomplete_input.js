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

  preventSubmit: function(e) {
    if (e.which === Support.Keys.enter) {
      e.preventDefault();
    }
  }
});
