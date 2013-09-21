var topicsFetcher = function(topics, interval) {
  var self = this;
  self._topics = topics;
  self._fetchHandler = function() {
    self._topics.fetch({cache: false});
  };
  setInterval(self._fetchHandler, interval);
}
