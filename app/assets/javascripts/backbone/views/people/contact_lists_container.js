Structural.Views.ContactListsContainer = Support.CompositeView.extend({
  className: 'contact-lists-container',
  initialize: function(options) {
    options = options || {};
  },
  render: function() {
    this.bar = new Structural.Views.ContactsListsBar();
    this.appendChild(this.bar);

    this.listView = new Structural.Views.ContactLists();
    this.appendChild(this.listView);

    this.editor = new Structural.Views.ContactListEditor();
    this.appendChild(this.editor)

  },
  showEditor: function(contact_list){
    this.editor.showEditor(contact_list);
  }
});
