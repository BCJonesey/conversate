Structural.Models.Topic = Backbone.Model.extend({
  initialize: function(attributes, options) {
    this.set('is_unread', this.get('unread_conversations') > 0);
    this.on('change:unread_conversations', Structural.updateTitleAndFavicon, Structural);

    this.conversations = new Structural.Collections.Conversations([], {topicId: this.id});
  },

  focus: function() {
    this.set('is_current', true);
  },
  unfocus: function() {
    this.set('is_current', false);
  }
});
