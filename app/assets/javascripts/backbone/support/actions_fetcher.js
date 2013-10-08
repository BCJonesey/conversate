//= require ./collection_fetcher

Support.ActionsFetcher = Support.CollectionFetcher({
  interval: 5000,
  event: 'changeConversation',
  collFunc: function(conversation) {
    return conversation.actions;
  }
});
