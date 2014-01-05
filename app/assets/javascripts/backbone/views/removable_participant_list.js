Structural.Views.RemovableParticipantList = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'participants-removable-list',
  template: JST.template('participants/removable_list'),
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.template({participants: this.collection}));
  },
  events: {
    'click .remove-participant': 'remove'
  },

  remove: function(e) {
    var target = $(e.target);
    var index = target.prevAll().length;
    this.trigger('remove', this.collection.at(index));
  }
})
