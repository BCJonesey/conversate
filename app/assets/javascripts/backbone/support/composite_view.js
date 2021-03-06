// Taken from thoughtbot's Backbone.js on Rails book.  (Location 1139
// in the Kindle edition.)

Support.CompositeView = function(options) {
  this.children = _([]);
  this.childrenByModelClientId = {};
  this.bindings = _([]);
  Backbone.View.apply(this, [options]);
};

_.extend(Support.CompositeView.prototype, Backbone.View.prototype, {
  leave: function(options) {
    options = options || {}

    this.unbind();
    this.unbindFromAll();

    if (options['keepEvents']) {
      this.$el.remove()
    } else {
      this.remove();
    }

    this._leaveChildren(options);
    this._removeFromParent();
  },

  bindTo: function(source, event, callback) {
    source.bind(event, callback, this);
    this.bindings.push({ source: source, event: event, callback: callback });
  },

  unbindFromAll: function() {
    this.bindings.each(function(binding) {
      binding.source.unbind(binding.event, binding.callback);
    });
    this.bindings = _([]);
  },

  isAttachedToViewTree: function() {
    return !!this.parent;
  },

  renderChild: function(view) {
    view.render();
    this.children.push(view);
    if (view.model) {
      this.childrenByModelClientId[view.model.cid] = view;
    }
    view.parent = this;
  },

  renderChildInto: function(view, container) {
    this.renderChild(view);
    $(container).empty().append(view.el);
  },

  appendChild: function(view) {
    this.renderChild(view);
    $(this.el).append(view.el);
  },

  appendChildTo: function(view, container) {
    this.renderChild(view);
    $(container).append(view.el);
  },

  prependChild: function(view) {
    this.renderChild(view);
    $(this.el).prepend(view.el);
  },

  prependChildTo: function(view, container) {
    this.renderChild(view);
    $(container).prepend(view.el);
  },

  // TODO: Fill this class out with full complement of insertion methods
  // (before, after, around, etc) either as you need them or when you get bored.

  insertChildBefore: function(view, sibling) {
    this.renderChild(view);
    $(sibling).before(view.el);
  },

  insertChildAfter: function(view, sibling) {
    this.renderChild(view);
    $(sibling).after(view.el);
  },

  _leaveChildren: function(options) {
    this.children.chain().clone().each(function(view) {
      if (view.leave) {
        view.leave(options);
      }
    });
  },

  reClass: function() {
    this.el.className = _.isFunction(this.className) ? this.className() : this.className
  },

  reRender: function() {
    this.$el.empty();
    this.render();
    this.reClass();
  },

  _removeFromParent: function() {
    if (this.parent) {
      this.parent._removeChild(this);
      this.parent = undefined;
    }
  },

  _removeChild: function(view) {
    var index = this.children.indexOf(view);
    this.children.splice(index, 1);
    if (view.model) {
      this.childrenByModelClientId = _.omit(this.childrenByModelClientId, view.model.cid);
    }
  }
});

Support.CompositeView.extend = Backbone.View.extend;
