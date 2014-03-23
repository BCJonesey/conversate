// A view for an actual conversation in the conversations list.

Structural.Views.Conversation = Support.CompositeView.extend({
  className: function() {
    var classes = 'cnv';

    if (this.model.unreadCount() > 0) {
      classes += ' cnv-unread';
    }

    if (this.model === Structural._conversation) {
      classes += ' cnv-current';
    }

    if (this.model.get('participants') && this.user &&
        !_(this.model.get('participants').map(function(p) { return p.id; })).contains(this.user.id)) {
      classes += ' cnv-not-participating';
    }

    return classes;
  },
  template: JST.template('conversations/conversation'),
  helpers: {
    classForUnreadCount: function(count) {
      var prefix = 'cnv-unread-count-';
      var suffix = 'many';
      if (count <= 5) {
        suffix = 'few';
      } else if (count <= 25) {
        suffix = 'some';
      }

      return prefix + suffix;
    }
  },
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this.model.on('updated', this.reRender, this);
    Structural.on('changeConversation', this.changeConversation, this);
  },
  render: function() {
    this.$el.html(this.template({
      conversation: this.model,
      helpers: this.helpers
    }));

    // The first time backbone calls className we don't have some data?
    this.reClass();

    return this;
  },
  reClass: function() {
    this.el.className = this.className();
  },
  reRender: function() {
    this.reClass();
    this.render();
  },
  events: {
    'click': 'view'
  },

  // TODO: I'm specifically trying to call out what we're doing with the view. Should this be in the controller?
  changeConversation: function(conversation) {
    this.reRender();
  },

  view: function(e) {
    e.preventDefault();

    Structural.viewConversation(this.model);
  }
});
