// A view for an actual folder in the folders list.

Structural.Views.Contact = Support.CompositeView.extend({
  className: "poop",
  template: JST.template('people/contacts/contact'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template({ contact: this.model }));
    return this;
  }
});
