Structural.Router = new (Backbone.Router.extend({
  routes: {
    '': 'index',
    'conversation/:slug/:id': 'conversation',
    'conversation/:slug/:id#message:messageId': 'message',
    'topic/:slug/:id': 'topic',
    'profile': 'profile',
    'admin': 'admin'
  },
  index: function() {
    // I really, really don't like this.
    Structural.focus({ topic: bootstrap.topics[0].id });
  },
  conversation: function(slug, id) {
    Structural.focus({ topic: bootstrap.conversation.topic_id,
                       conversation: id });
  },
  message: function(slug, id, messageId) {
    Structural.focus({ topic: bootstrap.conversation.topic_id,
                       conversation: id,
                       message: messageId });
  },
  topic: function(slug, id) {
    Structural.focus({ topic: id });
  },
  profile: function() {

  },
  admin: function() {

  },

  initialize: function(options) {
    console.log("router!");
  }
}))();
