Structural.Views.ContactListEditor = Support.CompositeView.extend({
  className: function(){
    return 'contact-list-edit-box-wrap ' + (this.shown ? "" : "hidden");
  },
  template: JST.template('people/contact_lists/contact_list_editor'),
  initialize: function(options) {
    var self = this;
    self.shown = false;
    self.model = null;
  },
  events: {
    'click .close-button': 'close',
    'click .cl-share-contact-list-btn': 'share',
    'click .contact-list-edit-save-button': 'save'
  },
  render:function(){
    if(this.model){
      this.$el.html(this.template({
        contactList: this.model,
        isShared: this.isShared
      }));

      if (this.isShared) {
        this.autocomplete = new Structural.Views.Autocomplete({
          dictionary: Structural._user.addressBook(),
          blacklist: new Structural.Collections.Participants([]),
          addSelectionToBlacklist: true,
          property: 'name'
        });
        this.removableList = new Structural.Views.RemovableParticipantList({
          collection: new Structural.Collections.Participants([])
        });

        this.autocomplete.on('select', this.removableList.add, this.removableList);
        this.removableList.on('remove', this.autocomplete.removeFromBlacklist, this.autocomplete);

        this.insertChildAfter(this.removableList, this.$('label[for="contact-list-participants"]'));
        this.insertChildAfter(this.autocomplete, this.$('label[for="contact-list-participants"]'));
      }
    }
  },
  showEditor: function(contactList){
    this.model = contactList;
    this.shown = true;
    var participants = contactList.get('participants');
    this.isShared = participants !== undefined && participants.length > 0;
    this.reRender();
  },
  close: function(){
    this.model = null;
    this.shown = false;
    this.reRender();
  },
  share: function() {
    this.isShared = true;
    this.reRender();
  },
  save: function(){
    this.clearErrors();
    var name = this.$('.contact-list-name-input').val();
    this.model.save({
      name: name
    },{
      success: this.saveSucess.bind(this),
      error: this.saveError.bind(this),
      patch: true,
      noToastOnError: true
    });
  },
  clearErrors: function(){
    this.$('.errors').text("");
    this.$('.errors').addClass("hidden");
  },
  saveSucess: function(){
    this.close();
  },
  saveError: function(){
    this.$('.errors').text("Problem Saving Folder");
    this.$('.errors').removeClass("hidden");
  }
});
