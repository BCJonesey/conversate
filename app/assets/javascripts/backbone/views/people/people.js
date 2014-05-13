Structural.Views.People = Support.CompositeView.extend({
  className: 'people water-cooler',
  initialize: function(options) {
    options = options || {};
    this.contactLists = options.contactLists
    this.user = options.user;
  },
  events: {
    'click .act-container .ui-back-button': 'showCnv',
    'click .cnv-container .ui-back-button': 'showFld',
    'click .fld-container .ui-back-button': 'showStb',
    'click .fld-popover-close-button':'showCnv'
  },
  render: function() {
    this.clContainer = new Structural.Views.ContactListsContainer({});
    this.cContainer = new Structural.Views.ContactsContainer({model: Structural._contactLists.at(0)});
    this.appendChild(this.clContainer);
    this.appendChild(this.cContainer);
  }
});
