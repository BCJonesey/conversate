Structural.Views.Actions = Support.CompositeView.extend({
  className: 'act-list ui-scrollable',
  noConversationTemplate: JST.template('actions/no_conversation'),
  loadingActionsTemplate: JST.template('actions/loading'),
  initialize: function(options) {
    this._wireEvents(this.collection);

    Structural.on('changeConversation', this.changeConversation, this);
    Structural.on('clearConversation', this.clearConversation, this);
    Structural.on('noConversationToView', this.noConversation, this);

    this._noConversationSelected = false;
    this._loadingActions = false;
  },
  _wireEvents: function(collection) {
    collection.on('add', this.renderAction, this);
    collection.on('reset', this.reRender, this);
    collection.on('addedSomeoneElsesMessage', this.scrollDownIfAtBottom, this);
    collection.on('actionsLoadedForFirstTime', this.reRender, this);
    collection.on('focusedView', this.scrollToTargetAtEarliestOpportunity, this);
    collection.on('doneLoading', this.reRender, this);
  },
  render: function() {
    this.focusedView = undefined;

    if (this._loadingActions) {
      this.$el.html(this.loadingActionsTemplate());
    } else if (this._noConversationSelected) {
      this.$el.html(this.noConversationTemplate());
    } else {
      this.collection.forEach(this.renderActionAlwaysAppend, this);
      this.scrollToTargetAtEarliestOpportunity(this.focusedView);
    }
    return this;
  },
  _makeNewActionView: function(action) {
    var view = new Structural.Views.Action({model: action});
    if (view.focused()) {
      this.focusedView = view;
    }
    return view;
  },
  renderAction: function(action) {
    var view = this._makeNewActionView(action)

    var index = this.collection.indexOf(action);
    var prevView = undefined;

    // In order to maintain the right follow on ordering, we need to insert
    // an action after the action most closely previous to it that has a view.

    if (index > 0) {
      for (var modelIndex = index - 1; modelIndex >= 0; modelIndex--) {
        var model = this.collection.at(modelIndex);
        if (this.childrenByModelClientId[model.cid]) {
          prevView = this.childrenByModelClientId[model.cid];
          break;
        }
      }
    }

    if (prevView) {
      this.insertChildAfter(view, prevView.el);
    } else {
      this.appendChild(view);
    }
  },
  renderActionAlwaysAppend: function(action) {
    var view = this._makeNewActionView(action);
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
    this._loadingActions = false;
    this._noConversationSelected = false;

    if (!Structural.Router.isActionFocused()) {
      this.collection.clearFocus();
    }

    this._wireEvents(this.collection);
    this.reRender();
  },
  clearConversation: function() {
    this.collection.off(null, null, this);
    this._loadingActions = true;
    this._noConversationSelected = false;
    this.reRender();
  },
  noConversation: function() {
    this._loadingActions = false;
    this._noConversationSelected = true;
    this.reRender();
  },

  scrollDownIfAtBottom: function() {
    if (this.isAtBottom()) {
      this.scrollToTargetAtEarliestOpportunity();
    }
  }
});

_.extend(Structural.Views.Actions.prototype, Support.Scroller);
