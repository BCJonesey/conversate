Structural.Views.AutocompleteOptions = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'autocomplete-options',
  template: JST.template('autocomplete/options'),
  initialize: function(options) {
    this._blacklist = options.blacklist;
    this._property = options.property;
    this._matches = [];
    this._targetIndex = 0;
  },
  render: function() {
    this.$el.empty();
    this.$el.html(this.template({
      matches: this._matches,
      property: this._property
    }));

    if (this._matches.length === 0) {
      this.$el.addClass('hidden');
    } else {
      this.$el.removeClass('hidden');
    }

    this._changeTargetIndex(this._targetIndex);
    this._centerTarget();

    return this;
  },
  events: {
    'mouseenter .option': 'setTarget',
    'click .option': 'select'
  },

  setTarget: function(e) {
    var index = this._getIndexFromEvent(e);
    this._changeTargetIndex(index);
  },
  select: function(e) {
    this.trigger('select');
  },
  target: function() {
    return this._matches[this._targetIndex];
  },
  updateOptionsList: function(pattern) {
    if (pattern === '') {
      this._matches = [];
    } else {
      var regex = new RegExp(pattern, 'gi');
      this._matches = _.filter(this.collection,function(item) {
        var isMatch = regex.test(item[this._property]) &&
                      this._blacklist.get(item.id) === undefined;
        // This gets automatically set because we use the 'g' flag.  If we don't
        // zero it it randomly drops matches.
        regex.lastIndex = 0;
        return isMatch;
      }, this);
    }
    this._targetIndex = 0;
    this.render();
    this.trigger('optionsUpdated', this._matches);
  },
  targetUp: function() {
    this._scrollTargetIndex(-1);
    this._centerTarget();
  },
  targetDown: function() {
    this._scrollTargetIndex(1);
    this._centerTarget();
  },
  clear: function() {
    this._matches = [];
    this._targetIndex = 0;
    this.render();
  },
  addToBlacklist: function(item) {
    // This and the Autocomplete view have a reference to the same instance of
    // the blacklist, so we don't actually need to do anything here.
  },
  removeFromBlacklist: function(item) {
    // This and the Autocomplete view have a reference to the same instance of
    // the blacklist, so we don't actually need to do anything here.
  },
  replaceBlacklist: function(blacklist) {
    this._blacklist = blacklist;
  },

  _getIndexFromEvent: function(e) {
    return $(e.target).prevAll().length;
  },
  _changeTargetIndex: function(newIndex) {
    $(this.$('.option')[this._targetIndex]).removeClass('target');
    this._targetIndex = newIndex;
    $(this.$('.option')[this._targetIndex]).addClass('target');
  },
  _scrollTargetIndex: function(offset) {
    var totalOptions = this.$('.option').length;
    this._changeTargetIndex(Math.min(totalOptions, Math.max(0, this._targetIndex + offset)));
  },
  _centerTarget: function() {
    var target  = this.$('.target');

    // I swear I have no idea how target could be valid object and have .postion()
    // return undefined, but that's what's happening.  Thanks, Eich.
    if (target.position()) {
      var center = this.el.scrollTop + target.position().top + (target.outerHeight() / 2);
      var scrollTop = center - this.$el.innerHeight() / 2;
      this.$el.scrollTop(scrollTop);
    }
  }
});
