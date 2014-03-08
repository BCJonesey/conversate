Structural.Views.RemovableParticipant = Support.CompositeView.extend({
  tagName: 'li',
  className: function() {
    var classes = 'removable-participant';
    if (this.model.get('known')) {
      classes += ' unknown-participant';
    }
    return classes;
  },
  template: JST.template('participants/removable_participant'),
  initialize: function(options) {
  },
  render: function() {
    this.$el.html(this.template({participant: this.model}));
  },
  events: {
    'click .remove-participant': 'removeParticipant',
    'click .unknown-participant' : 'showAddContactForm',
    'click .btn-save' : 'addContact',
    'click .act-add-contact-toggle': 'toggleAddContactForm'
  },
  removeParticipant: function(e) {
  	this.model.collection.remove(this.model);
  },
  toggleAddContactForm: function(e){
    this.$el.find('.act-add-contact-form').toggleClass('hidden');

  },
  addContact: function(e){
     var contact = new Structural.Models.Contact({contact_list_id:this.$el.find(".contact-list-select").val(), user_id:this.model.id});
     contact.save();
  }
});
