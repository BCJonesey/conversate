// A view for an actual folder in the folders list.

Structural.Views.ContactsListsBar = Support.CompositeView.extend({
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
  }
});
