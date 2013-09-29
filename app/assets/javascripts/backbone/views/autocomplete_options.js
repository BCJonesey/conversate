Structural.Views.AutocompleteOptions = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'token-options',
  template: JST['backbone/templates/participants/options'],
  initialize: function(options) {
    options = options || {};
    this.participants = options.participants;
    this.matches = [];
    this.targetIndex = 0;

    Structural.on('changeConversation', this._changeConversation, this);
  },
  render: function() {
    this.$el.empty();
    this.$el.html(this.template({users: this.matches}));
    if (this.matches.length === 0) {
      this.$el.addClass('hidden');
    }
    else {
      this.$el.removeClass('hidden');
    }
    this._changeTargetIndex(this.targetIndex);
    this._centerSelectedOption();
  },
  events: {
    'mouseenter .token-option': 'focusAutocompleteTarget',
    'click .token-option': 'selectOption'
  },

  focusAutocompleteTarget: function(e) {
    var index = this._getIndexFromEvent(e);
    this._changeTargetIndex(index);
  },
  moveAutocompleteTarget: function(direction) {
    var index = Math.min(this.matches.length - 1,
                  Math.max(0, this.targetIndex + (direction === 'up' ? -1 : 1)));
    this._changeTargetIndex(index);
    this._centerSelectedOption();
  },
  changeAutocompleteOptions: function(pattern) {
    if (pattern === '') {
      this.matches = [];
    } else {
      var regex = new RegExp(pattern, 'gi');
      this.matches = this.collection.filter(function(u) {
        return regex.test(u.get('name')) &&
               this.participants.get(u.id) === undefined;
      }, this);
    }
    this.targetIndex = 0;
    this.render();
  },
  currentOption: function() {
    return this.matches[this.targetIndex];
  },
  clear: function() {
    this.matches = [];
    this.targetIndex = 0;
    this.render();
  },
  selectOption: function(e) {
    this.trigger('selectAutocompleteTarget');
  },

  _getIndexFromEvent: function(e) {
    // This is dumb, but I don't see a better way in the JQuery API.
    var index = 0;
    var prev = $(e.target).prev();
    while(prev.length !== 0) {
      index += 1;
      prev = prev.prev();
    }
    return index;
  },
  _changeTargetIndex: function(newIndex) {
    $(this.$('.token-option')[this.targetIndex]).removeClass('target');
    this.targetIndex = newIndex;
    $(this.$('.token-option')[this.targetIndex]).addClass('target');
  },
  _centerSelectedOption: function() {
    var target = this.$('.target');

    // I swear I have no idea how target could be a valid object and have .position()
    // return undefined, but that's what's happening. Thanks, Eich.
    if (target.position()) {
      var center = this.el.scrollTop + target.position().top + (target.outerHeight() / 2);
      var scrollTop = center - this.$el.innerHeight() / 2;
      this.$el.scrollTop(scrollTop);
    }
  },
  _changeConversation: function(conversation) {
    this.participants = conversation.participants;
    this.render();
  }
});
