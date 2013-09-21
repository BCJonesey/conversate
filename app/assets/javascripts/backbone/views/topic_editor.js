Structural.Views.TopicEditor = Support.CompositeView.extend({
  className: 'tpc-editor',
  template: JST['backbone/templates/topics/editor'],
  initialize: function(options) {
    options = options || {};
    this._addressBook = options.addressBook;
  },
  render: function(topic) {
    if (topic) {
      this._participantEditor = new Structural.Views.ParticipantEditor({
        participants: topic.get('users'),
        addressBook: this._addressBook
      });

      this.$el.html(this.template({topic: topic}));
      this.insertChildAfter(this._participantEditor, this.$('label[for="folder-participants"]'));
    }
    return this;
  },

  events: {
    'click .ef-save-button': 'save'
  },

  show: function(topic) {
    this._topic = topic;
    this.render(topic);
    this.$('.modal-background').removeClass('hidden');
  },
  save: function(e) {
    e.preventDefault();
    if (this._topic) {
      var name = this.$('.ef-name-input').val();
      if (name.length === 0) { return; }

      var participants = this._participantEditor.currentParticipants();

      this._topic.update(name, participants);
      this.$('.modal-background').addClass('hidden');
    }
  }
});
