Structural.Collections.Conversations = Backbone.Collection.extend({
	model: Structural.Models.Conversation,
  url: function() {
    return Structural.apiPrefix + '/topics/' + this.topicId + '/conversations';
  },
  initialize: function(data, options) {
    options = options || {};
    this.topicId = options.topicId;
  },
  comparator: function(conversation) {
    return -(conversation.get('most_recent_event'));
  },

  focus: function(id) {
    var conversation = this.get(id);
    if(conversation) {
      conversation.focus();
    }

    this.filter(function(cnv) { return cnv.id != id; }).forEach(function(cnv) {
      cnv.unfocus();
    })
  },
  setTopic: function(id) {
    this.topicId = id;
  },
  changeTopic: function(id, success) {
    this.setTopic(id);
    this.reset();
    this.fetch({
      reset: true,
      remove: true,
      success: success
    });
  }
});
