// A view for an actual folder in the folders list.

Structural.Views.ContactsBar = Support.CompositeView.extend({
  className: function() {
    var classes = 'poop';
  },
  template: JST.template('people/contacts/contacts_bar'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
});
