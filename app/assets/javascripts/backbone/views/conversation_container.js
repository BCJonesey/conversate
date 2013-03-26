Structural.Views.ConversationContainer = Support.CompositeView.extend({
  className: 'cnv-container',
  initialize: function(options) {
    options = options || {};
    this.conversations = options.conversations;
  },
  render: function() {
    var toolbar = new Structural.Views.ConversationToolbar();
    var list = new Structural.Views.Conversations({collection: this.conversations});

    this.appendChild(toolbar);
    this.appendChild(list);
  }
});
