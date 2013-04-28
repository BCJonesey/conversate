Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  url: function() {
    return Structural.apiPrefix + '/topics/' + this.topicId + '/conversations';
  },
  initialize: function(data, options) {
    options = options || {};
  },
  comparator: 'most_recent_message',

  focus: function(id) {
    // findWhere is coming in backbone 1.0.0.
    var conversation = this.where({id: id}).pop();
    if(conversation) {
      conversation.focus();
    }

    this.filter(function(cnv) { return cnv.id != id; }).forEach(function(cnv) {
      cnv.unfocus();
    })
  },
  setTopic: function(id) {
    this.topicId = id;
  }
});

