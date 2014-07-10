Structural.Views.People = Support.CompositeView.extend({
  className: 'people water-cooler',
  initialize: function(options) {
    this.checkIfContactListSelected();
    this.listenTo(Structural._user, 'addressBookUpdated', this.checkIfContactListSelected);
  },
  render: function() {
    this.clContainer = new Structural.Views.ContactListsContainer({});
    this.appendChild(this.clContainer);
    this.cContainer = new Structural.Views.ContactsContainer({});
    this.appendChild(this.cContainer);
  },
  // If we do not have a contact list selected, try to set one as selected
  // every time we update the address book.
  checkIfContactListSelected: function() {
    if(Structural._selectedContactListId && !Structural._contactLists.get(Structural._selectedContactListId)){
      Structural._selectedContactListId = null;
    }
    if(!Structural._selectedContactListId && Structural._contactLists.length > 0){
      Structural._contactLists.at(0).show();
    }
  }
});
