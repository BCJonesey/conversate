// A view for an actual folders list.

Structural.Views.ContactLists = Support.CompositeView.extend({
  className: 'contact-lists ui-scrollable',
  initialize: function(options) {
    var self = this;
    this.listenTo(Structural._user, 'addressBookUpdated', this.reRender);
  },
  render: function() {
    Structural._contactLists.forEach(this.renderContactList, this);
    return this;
  },
  renderContactList: function(contactList) {
    this.appendChild(new Structural.Views.ContactList({model: contactList}));
  }
});
