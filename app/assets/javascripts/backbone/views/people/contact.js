// A view for an actual contact in the contacts list.

Structural.Views.Contact = Support.CompositeView.extend({
  className: "contact",
  template: JST.template('people/contacts/contact'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template({ contact: this.model }));
    return this;
  }
});
