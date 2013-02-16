ConversateApp.Collections.Messages = Backbone.Collection.extend({
  model: ConversateApp.Models.Message,
  url: '/events'
});
