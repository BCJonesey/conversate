Structural.Views.Conversation = Support.CompositeView.extend({
  className: function() {
    var classes = 'cnv';
    if (this.model.get('is_unread')) {
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
  template: JST['backbone/templates/conversations/conversation'],
  initialize: function(options) {
    options = options || {};
    this.user = options.user;

    this.model.on('updated', this.reRender, this);
  },
  render: function() {
    this.$el.html(this.template({conversation: this.model}));

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

  view: function(e) {
    e.preventDefault();
    Structural.viewConversation(this.model);
  }
});
