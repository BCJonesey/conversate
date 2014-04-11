//= require ./collection_fetcher

Support.ContactsFetcher = Support.CollectionFetcher({
  interval: {min: 50000, max: 600000},
  sucess: function(){_.flatten(Structural._contactLists.map(function(cl){return cl.get("contacts").map(function(x){return x.get("user_id")})}))}
});
