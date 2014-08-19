// A view for the header of the contact_lists list.

Structural.Views.ContactsListsBar = Support.CompositeView.extend({
  events: {
    'click .contacts-new-contact-list': 'newContactList'
  },
  className: function() {
    var classes = 'contact-lists-header';
    return classes;
  },
  template: JST.template('people/contact_lists/contact_lists_header'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template());
    return this;
  },
  newContactList: function(){
    this.parent.showEditor(new Structural.Models.ContactList());
  }
});
