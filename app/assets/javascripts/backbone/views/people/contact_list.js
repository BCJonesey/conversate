// A view for an actual contact_list in the contact_lists list.

Structural.Views.ContactList = Support.CompositeView.extend({
  className: function(){
    return 'contact-list ' + (this.model.id == Structural._selectedContactListId ? "is-selected" : "");
  },
  events: {
    'click .cl-details-toggle': 'editContactList',
    'click': 'showContactList'
  },
  template: JST.template('people/contact_lists/contact_list'),
  initialize: function(options) {
    var self = this;
    this.listenTo(this.model, "sync", this.reRender)
    this.listenTo(Structural._people, 'switchContactList', this.reClass);
  },
  render: function() {
    this.$el.html(this.template({ contactList: this.model }));
    return this;
  },
  showContactList: function(){
    this.model.show();
  },
  editContactList: function(){
    this.parent.parent.showEditor(this.model);
  }
});
