Structural.Models.Topic = Backbone.Model.extend({
  urlroot: Structural.apiPrefix + '/topics',

  initialize: function(attributes, options) {
    this.set('is_unread', this.get('unread_conversations') > 0);
    this.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);
    if (this.get('users')) {
      this.set('users', new Structural.Collections.TopicParticipants(this.get('users')));
    }
    this.conversations = new Structural.Collections.Conversations([], {topicId: this.id});
  },

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  },

  update: function(name, participants) {
    this.set('name', name);
    this.set('users', participants);
    this.save();
  }
});
