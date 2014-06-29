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
    'click .contact-list-edit-save-button': 'save'
  },
  render:function(){
    if(this.model){
      this.$el.html(this.template({ contactList: this.model }));
    }
  },
  showEditor: function(contact_list){
    this.model = contact_list;
    this.shown = true;
    this.reRender();
  },
  close: function(){
    this.model = null;
    this.shown = false;
    this.reRender();
  },
  save: function(){
    this.clearErrors();
    var name = this.$('.contact-list-name-input').val();
    this.model.save({name: name},{success:this.saveSucess.bind(this),error:this.saveError.bind(this), patch: true});
  },
  clearErrors: function(){
    this.$('.errors').text("");
    this.$('.errors').addClass("hidden");
  },
  saveSucess: function(){
    this.close();
  },
  saveError: function(){
    this.$('.errors').text("Shit went sideways!");
    this.$('.errors').removeClass("hidden");
  }
});
