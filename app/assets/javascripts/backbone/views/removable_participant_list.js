Structural.Views.RemovableParticipantList = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'participants-removable-list',
  template: JST.template('participants/removable_list'),
  initialize: function(options) {
    this.addAtEnd = options.addAtEnd || false;
    this.collection.on('remove', this.render, this);
  },
  render: function() {
    this.collection.forEach(this.renderParticipant, this);
  },
  removeParticipant: function(participant) {
    this.trigger('remove', participant);
    this.collection.remove(participant);
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
  renderParticipant: function(participant) {
    var view = new Structural.Views.RemovableParticipant({model: participant});
    view.on("removeParticipant", this.removeParticipant, this)
    this.appendChild(view);
  },
  participants: function() {
    return this.collection.clone();
  }
})
