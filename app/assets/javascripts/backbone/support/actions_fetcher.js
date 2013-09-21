Support.ActionsFetcher = function(conversation, interval) {
  var self = this;
  self._conversation = conversation;

  self._fetchHandler = function() {
    self._conversation.actions.fetch({cache: false});
  };
  setInterval(self._fetchHandler, interval);

  Structural.on('changeConversation', function(newConversation) {
    self._conversation = newConversation;
  });
}
