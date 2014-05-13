// A view for an actual folders list.

Structural.Views.Contacts = Support.CompositeView.extend({
  className: 'Contacts ui-scrollable',
  initialize: function(options) {
    var self = this;
  },
  render: function() {

    this.collection.forEach(this.renderContact, this);
    return this;
  },
  renderContact: function(contact) {
    this.appendChild(new Structural.Views.Contact({model: contact}));
  }
});
