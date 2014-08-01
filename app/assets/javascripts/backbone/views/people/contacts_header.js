// A view for the header of the contacts list.

Structural.Views.ContactsBar = Support.CompositeView.extend({
  className: 'contacts-header',
  template: JST.template('people/contacts/contacts_header'),
  initialize: function(options) {
    this.addInviteDialog = new Structural.Views.AddInviteDialog();
  },
  render: function() {
    this.$el.html(this.template({ contactList: this.model }));
    this.appendChildTo(this.addInviteDialog, this.$('.add-invite'));
    return this;
  }
});
