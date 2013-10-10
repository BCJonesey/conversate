//= require ./collection_fetcher

Support.ActionsFetcher = Support.CollectionFetcher({
  interval: {min: 5000, max: 60000},
  event: 'changeConversation',
  collFunc: function(conversation) {
    return conversation.actions;
  }
});
