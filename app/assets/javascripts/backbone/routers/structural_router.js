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
    Structural.focus({ topic: Structural._topics.at(0).id });
  },
  conversation: function(slug, id) {
    Structural.focus({ topic: Structural._conversation.topic_id,
                       conversation: id });
    this._fixSlug('conversation/', slug, '/' + id, Structural._conversation.get('title'));
  },
  message: function(slug, id, messageId) {
    Structural.focus({ topic: Structural._conversation.topic_id,
                       conversation: id,
                       message: messageId });
    this._fixSlug('conversation/', slug, '/' + id + '#message' + messageId, Structural._conversation.get('title'));
  },
  topic: function(slug, id) {
    Structural.focus({ topic: id });
    this._fixSlug('topic/', slug, '/' + id, Structural._topics.where({id: id|0})[0].get('name'));
  },
  profile: function() {

  },
  admin: function() {

  },

  initialize: function(options) {
  },
  slugify: function(s) {
    return encodeURIComponent(s.toLowerCase()
                               .replace(/[ _]/g, '-')
                               .replace(/[^a-zA-Z0-9-]/g, ''));
  },

  _fixSlug: function(prefix, slug, suffix, correct) {
    var correctSlug = this.slugify(correct);
    if (slug !== correctSlug) {
      this.navigate(prefix + correctSlug + suffix, {replace: true});
    }
  }
}))();
