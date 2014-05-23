// A view for an actual folders list.

Structural.Views.Contacts = Support.CompositeView.extend({
  template: JST.template('people/contacts/contacts'),
  className: 'contacts ui-scrollable',
  initialize: function(options) {
    var self = this;
  },
  render: function() {
    this.$el.html(this.template());
    this.collection.forEach(this.renderContact, this);
    return this;
  },
  renderContact: function(contact) {
    this.appendChildTo(new Structural.Views.Contact({model: contact}), this.$('.contacts-table'));
  }
});
