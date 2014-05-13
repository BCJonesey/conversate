// A view for the actual conversations list.

Structural.Views.ContactsContainer = Support.CompositeView.extend({
  className: 'poop',
  initialize: function(options) {
    options = options || {};
    this.contactList = options.contactList;

    Structural.on('changeContactList', this.changeFolder, this);

    // The viewOrder property is the order that sections show up in the DOM,
    // the priority property controls the order that we check the section
    // predicates.  The first section (in priority order) whose predicate is
    // true for a conversation is the section we put that convo in.

  },
  render: function() {
    this.$el.empty();
    this.contactsBar = new Structural.Views.ContactsBar({model: this.model});
    this.appendChild(this.contactsBar);
    this.contacts = new Structural.Views.Contacts({collection: this.model.get("contacts")});
    this.appendChild(this.contacts);
    return this;
  },
  reRender: function() {
    this.$el.empty();
    this.render();
  },



});

