var topicFetcher = function(conversations, interval) {
  var self = this;
  self._conversations = conversations;
  self._fetchHandler = function() {
    self._conversations.fetch({cache: false});
  };
  setInterval(self._fetchHandler, interval);
  Structural.on('changeTopic', function(newConversations) {
    // TODO: Hook up this event.
    self._conversations = newConversations;
  });
}
