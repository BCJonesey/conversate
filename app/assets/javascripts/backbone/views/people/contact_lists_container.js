// A view for the folders toolbar and a container for the actual
// folders list.

Structural.Views.ContactListsContainer = Support.CompositeView.extend({
  className: 'contact-lists-container',
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.bar = new Structural.Views.ContactsListsBar();
    this.appendChild(this.bar);

    this.listView = new Structural.Views.ContactLists({collection: Structural._contactLists});
    this.appendChild(this.listView);
  }
});
