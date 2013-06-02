Structural.Collections.Participants = Backbone.Collection.extend({
  model: Structural.Models.Participant,
  url: function() {
    return Structural.apiPrefix + '/conversations/' + this.conversationId + '/participants';
  },
  intialize: function(data, options) {
    options = options || {};
    this.conversationId = options.conversation;
  },
  comparator: 'last_updated_time',

  changeConversation: function(conversationId) {
    this.conversationId = conversationId;
    this.reset();
    this.fetch({reset: true});
  }
})
