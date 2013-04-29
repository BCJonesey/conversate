Structural.Views.Conversation = Support.CompositeView.extend({
  className: function() {
    var classes = 'cnv';
    if (this.model.get('is_unread')) {
      classes += ' cnv-unread';
    }

    if (this.model.get('is_current')) {
      classes += ' cnv-current';
    }
    return classes;
  },
  template: JST['backbone/templates/conversations/conversation'],
  initialize: function(options) {
    this.model.on('change', this.reRender, this);
  },
  render: function() {
    this.$el.html(this.template({conversation: this.model}));
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
