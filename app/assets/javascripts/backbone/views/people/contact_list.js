// A view for an actual folder in the folders list.

Structural.Views.ContactList = Support.CompositeView.extend({
  className: 'contact-list',
  template: JST.template('people/contact_lists/contact_list'),
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template({ contactList: this.model }));
    return this;
  }
});
