Structural.Views.RemovableParticipantList = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'participants-removable-list',
  template: JST.template('participants/removable_list'),
  initialize: function(options) {
    this.addAtEnd = options.addAtEnd || false;
  },
  render: function() {
    this.$el.html(this.template({participants: this.collection}));
  },
  events: {
    'click .remove-participant': 'removeParticipant',
    'click .unknown-participant' : 'showAddContactForm',
    'click .act-add-contact-toggle': 'toggleAddContactForm'
  },
  showAddContactForm: function(e)
  {
    var model = this.getParticipantFromAction(e);
  },
  removeParticipant: function(e) {
    var model = this.getParticipantFromAction(e);
    this.trigger('remove', model);
    this.collection.remove(model);
    this.render();
  },
  add: function(model) {
    var index = this.addAtEnd ? this.collection.length : 0;
    this.collection.add(model, {at: index});
    this.render();
  },
  replace: function(list) {
    this.collection = list.clone();
    this.render();
  },

  participants: function() {
    return this.collection.clone();
  },
  getParticipantFromAction: function(e){
    var target = $(e.target).closest('.removable-participant');
    var index = target.prevAll().length;
    return this.collection.at(index);
  },
  toggleAddContactForm: function(e){
    $(e.target).closest('.removable-participant').find('.act-add-contact-form').toggleClass('hidden');

  }
})
