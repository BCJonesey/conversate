Structural.Views.ContactLists = Support.CompositeView.extend({
  className: 'contact-lists ui-scrollable',
  loadingTemplate: JST.template('people/contact_lists/loading_contact_lists'),
  initialize: function(options) {
    var self = this;
    this.listenTo(Structural._user, 'addressBookUpdated', this.reRender);
  },
  render: function() {
    if (Structural._contactLists.length === 0) {
      this.$el.html(this.loadingTemplate());
    } else {
      Structural._contactLists.forEach(this.renderContactList, this);
    }
    return this;
  },
  renderContactList: function(contactList) {
    this.appendChild(new Structural.Views.ContactList({model: contactList}));
  }
});
