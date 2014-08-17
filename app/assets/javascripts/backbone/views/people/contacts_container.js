// A view for the actual conversations list.

Structural.Views.ContactsContainer = Support.CompositeView.extend({
  className: 'contacts-container',
  initialize: function(options) {
    options = options || {};
    this.contactList = options.contactList;

    this.listenTo(Structural._people, 'switchContactList', this.reRender);

    // The viewOrder property is the order that sections show up in the DOM,
    // the priority property controls the order that we check the section
    // predicates.  The first section (in priority order) whose predicate is
    // true for a conversation is the section we put that convo in.

  },
  render: function() {
    this.$el.empty();
    if(Structural._selectedContactListId){
      this.contactsBar = new Structural.Views.ContactsBar({
        model: Structural._contactLists.get(Structural._selectedContactListId)
      });
      this.appendChild(this.contactsBar);
      this.contacts = new Structural.Views.Contacts({
        contactListId: Structural._selectedContactListId
      });
      this.appendChild(this.contacts);
    }
    return this;
  },


});

