Structural.Router = new (Backbone.Router.extend({
  routes: {
    '': 'index',
    'conversation/:slug/:id': 'conversation',
    'conversation/:slug/:id#message:messageId': 'message',
    'folder/:slug/:id': 'folder',
    'profile': 'profile',
    'admin': 'admin',
    'people': 'people'
  },
  index: function() {
    Structural.focus({ folder: Structural._folders.at(0).id });
  },
  conversation: function(slug, id) {
    Structural.focus({ folder: this._folderIdForConversation(Structural._conversation),
                       conversation: id });
    this._fixSlug('conversation/', slug, '/' + id, Structural._conversation.get('title'));
  },
  message: function(slug, id, messageId) {
    Structural.focus({ folder: this._folderIdForConversation(Structural._conversation),
                       conversation: id,
                       message: messageId });
    this._fixSlug('conversation/', slug, '/' + id + '#message' + messageId, Structural._conversation.get('title'));
  },
  folder: function(slug, id) {
    Structural.focus({ folder: id });
    this._fixSlug('folder/', slug, '/' + id, Structural._folders.get(id|0).get('name'));
  },
  profile: function() { },
  admin: function() { },
  people: function() { },

  _folderIdForConversation: function(conversation) {
    if (_.contains(conversation.get('folder_ids'), Structural._folder.id)) {
      return Structural._folder.id;
    }
    return conversation.get('folder_ids')[0];
  },

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
  folderPath: function(folder) {
    return 'folder/' +
           this.slugify(folder.get('name')) +
           '/' + folder.id;
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
  folderHref: function(folder) {
    return '/' + this.folderPath(folder);
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
