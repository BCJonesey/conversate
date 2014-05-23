// A view for an actual folder in the folders list.

Structural.Views.ContactsBar = Support.CompositeView.extend({
  className: function() {
    var classes = 'contacts-header';
    return classes;
  },
  template: JST.template('people/contacts/contacts_header'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  }
});
