Structural.Views.Actions = Support.CompositeView.extend({
  className: 'act-list',
  initialize: function(options) {
    this._wireEvents(this.collection);

    Structural.on('changeConversation', this.changeConversation, this);
    Structural.on('clearConversation', this.clearConversation, this);

  },
  _wireEvents: function(collection) {
    collection.on('add', this.renderAction, this);
    collection.on('reset', this.reRender, this);
    collection.on('addedSomeoneElsesMessage', this.scrollDownIfAtBottom, this);
    collection.on('actionsLoadedForFirstTime', this.reRender, this);
  },
  render: function() {
    this.collection.forEach(this.renderAction, this);
    this.scrollDownAtEarliestOpportunity();
    return this;
  },
  renderAction: function(action) {
    var view = new Structural.Views.Action({model: action});
    this.appendChild(view);
  },
  reRender: function() {
    this.clearView();
    this.render();
  },
  clearView: function() {
    this.children.each(function(view) {
      view.leave();
    })
    this.$el.empty();
  },
  changeConversation: function(conversation) {
    this.collection.off(null, null, this);
    this.collection = conversation.actions;
    this._wireEvents(this.collection);
    this.reRender();
  },
  clearConversation: function() {
    this.collection.off(null, null, this);
    this.clearView();
  },

  // Sometimes when we want to scroll down the actions list hasn't actually been
  // added to the DOM yet, and you can't scroll things that aren't in the DOM.
  scrollDownAtEarliestOpportunity: function() {
    var self = this;
    var scrollUnlessAtBottom = function() {
      if (self.isAtBottom()) {
        clearInterval(self._scrollerIntervalId);
      } else {
        self.scrollToBottom();
      }
    };
    scrollUnlessAtBottom();

    if (this._scrollerIntervalId) {
      clearInterval(this._scrollerIntervalId);
    }
    this._scrollerIntervalId = setInterval(scrollUnlessAtBottom, 300);
  },
  scrollDownIfAtBottom: function() {
    if (this.isAtBottom()) {
      this.scrollDownAtEarliestOpportunity();
    }
  }
});

_.extend(Structural.Views.Actions.prototype, Support.Scroller);
