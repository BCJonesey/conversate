Structural.Collections.Participants = Backbone.Collection.extend({
  model: Structural.Models.Participant,
  url: function() {
    return Structural.apiPrefix + '/conversations/' + this.conversationId + '/participants';
  },
  initialize: function(data, options) {
    options = options || {};
    this.conversationId = options.conversation;
  },
  comparator: 'last_updated_time'
})
