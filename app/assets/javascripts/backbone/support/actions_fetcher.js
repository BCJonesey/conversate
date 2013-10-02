//= require ./collection_fetcher

Support.ActionsFetcher = Support.CollectionFetcher(
  5000,
  'changeConversation',
  function(conversation) {
    return conversation.actions;
  });
