Structural.Views.People = Support.CompositeView.extend({
  className: 'people water-cooler',
  initialize: function(options) {
  },
  render: function() {
    this.clContainer = new Structural.Views.ContactListsContainer({});
    this.appendChild(this.clContainer);
    this.cContainer = new Structural.Views.ContactsContainer({});
    this.appendChild(this.cContainer);
  }
});
