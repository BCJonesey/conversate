Structural.Router = new (Backbone.Router.extend({
  routes: {
    '': 'index',
    'conversation/:slug/:id': 'conversation',
    'conversation/:slug/:id#message:messageId': 'message',
    'topic/:slug/:id': 'topic',
    'profile': 'profile',
    'admin': 'admin',
    'people': 'people'
  },
  index: function() {
    Structural.focus({ topic: Structural._topics.at(0).id });
  },
  conversation: function(slug, id) {
    Structural.focus({ topic: Structural._conversation.get('topic_id'),
                       conversation: id });
    this._fixSlug('conversation/', slug, '/' + id, Structural._conversation.get('title'));
  },
  message: function(slug, id, messageId) {
    Structural.focus({ topic: Structural._conversation.get('topic_id'),
                       conversation: id,
                       message: messageId });
    this._fixSlug('conversation/', slug, '/' + id + '#message' + messageId, Structural._conversation.get('title'));
  },
  topic: function(slug, id) {
    Structural.focus({ topic: id });
    this._fixSlug('topic/', slug, '/' + id, Structural._topics.get(id|0).get('name'));
  },
  profile: function() { },
  admin: function() { },
  people: function() { },

  initialize: function(options) {
  },
  slugify: function(s) {
    return encodeURIComponent(s.toLowerCase()
                               .replace(/[ _]/g, '-')
                               .replace(/[^a-zA-Z0-9-]/g, ''));
  },

  /* *Path functions are suitable for passing to Structural.Router.navigate,
     while *Href functions are suitable for including in href attributes. */
  indexPath: function() {
    return '';
  },
  conversationPath: function(conversation) {
    return 'conversation/' +
           this.slugify(conversation.get('title')) +
           '/' + conversation.id;
  },
  messagePath: function(conversation, message) {
    return this.conversationPath(conversation) +
           '#message' + message.id;
  },
  topicPath: function(topic) {
    return 'topic/' +
           this.slugify(topic.get('name')) +
           '/' + topic.id;
  },
  adminPath: function() {
    return 'admin';
  },
  profilePath: function() {
    return 'profile';
  },
  peoplePath: function() {
    return 'people';
  },
  logoutPath: function() {
    return 'session/logout';
  },
  indexHref: function() {
    return '/' + this.indexPath();
  },
  conversationHref: function(conversation) {
    return '/' + this.conversationPath();
  },
  messageHref: function(conversation, message) {
    return '/' + this.messagePath(conversation, message);
  },
  topicHref: function(topic) {
    return '/' + this.topicPath(topic);
  },
  adminHref: function() {
    return '/' + this.adminPath();
  },
  profileHref: function() {
    return '/' + this.profilePath();
  },
  peopleHref: function() {
    return '/' + this.peoplePath();
  },
  logoutHref: function() {
    return '/' + this.logoutPath();
  },

  _fixSlug: function(prefix, slug, suffix, correct) {
    var correctSlug = this.slugify(correct);
    if (slug !== correctSlug) {
      this.navigate(prefix + correctSlug + suffix, {replace: true});
    }
  }
}))();
