Structural.Views.RemovableParticipant = Support.CompositeView.extend({
  tagName: 'li',
  className: function() {
    var classes = 'removable-participant';
    if (this.model.is_known()) {
      classes += ' known-participant';
    }
    else{
      classes += ' unknown-participant';
    }
    return classes;
  },
  template: JST.template('participants/removable_participant'),
  initialize: function(options) {
    this.listenTo(Structural._user, 'addressBookUpdated', this.reRender);
  },
  render: function() {
    this.$el.html(this.template({participant: this.model}));
  },
  events: {
    'click .remove-participant': 'removeParticipant',
    'click .unknown-participant' : 'showAddContactForm',
    'click .btn-save' : 'addContact',
    'click .btn-cancel': 'hideAddContactForm',
    'click .act-add-contact-toggle': 'showAddContactForm'
  },
  removeParticipant: function(e) {
    this.trigger("removeParticipant", this.model);
  },
  showAddContactForm: function(e){
    this.$el.find('.act-add-contact-form').removeClass('hidden');
    this.$el.find('.error-text').addClass('hidden');
  },
  hideAddContactForm: function(e){
    this.$el.find('.act-add-contact-form').addClass('hidden');
  },
  addContact: function(e){
     var contact = new Structural.Models.Contact({
      contact_list_id:this.$el.find(".contact-list-select").val(),
      user_id:this.model.id
    });
     this.$el.find('.error-text').addClass('hidden');
     var self = this;
     contact.save(null,{error: function(){self.addContactError()},success:function(){self.addContactSuccess()}});
  },
  addContactError: function(){
    this.$el.find('.error-text').removeClass('hidden');
  },
  addContactSuccess: function(){
    this.hideAddContactForm();
    Structural._user.addUserToAddressBook(this.model.id,this.model.escape("name"));
  },
  reRender: function(){
    this.reClass();
    this.render();
  },
  reClass: function() {
    this.el.className = this.className();
  }
});
