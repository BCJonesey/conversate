Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  initialize: function(data, options) {
    options = options || {};
    if (options.conversation) {
      this.url = Structural.apiPrefix + '/topics/' + options.topic + '/conversations';
    }
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
  }
});

