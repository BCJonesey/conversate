// A view for the header of the contacts list.

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
    this.$el.html(this.template({ contactList: this.model }));
    return this;
  }
});
