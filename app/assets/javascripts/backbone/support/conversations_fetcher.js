//= require ./collection_fetcher

Support.ConversationsFetcher = Support.CollectionFetcher(
  60000,
  'changeFolder',
  function(folder) {
    return folder.conversations;
  });
