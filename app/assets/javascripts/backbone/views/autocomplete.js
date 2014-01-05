/* BIG ASS COMMENT ABOUT THIS DRAFT IMPLEMENTATION OF AUTOCOMPLETE.
   READ THIS FIRST, GODDAMNIT.

I stopped implementing this halfway through - these are notes to whoever picks
this up, either myself or someone else.

In order to do autocomplete (and, by extension, editing participants) right the
fundamental thing that needs to happen is that we need to decouple selecting
an item from a dictionary (with autocomplete to help you) from showing that
item in a list.  This is how we're going to do that:
  1) Make a generic autocomplete input thing.  That's this view.
  2) The core API into the autocomplete view will be the 'select' event, which
     autocomplete will fire this when the user picks an item.
  3) On select, whatever view contains the autocomplete will handle the new
     item, probably by displaying it somehow.
  4) The only wrinkle to manage is the blacklist.  Since we don't want to
     include people already on a conversation in the autocomplete, we have to
     keep track of a blacklist of items.  Shouldn't be too hard.
  5) That's it.  Figuring out the list of changed things to send to the server
     or whatever is out of scope for this view.  It goes somewhere else.

This view is composed of two sub-views.  The input and the options.  They each
fire events that this view wires together.  I think the code for that is
pretty much right.  The input view has a skeleton that needs to be filled out
(look at parts of the current Participants view for inspiration), and the
options view needs to be adapted to do what we now want.

Since I never got close to there I don't have the details for how to make the
views that contain this view, but I think there'll be three of them: one each
for the folder, conversation and new conversation participants.  Talk to Will
for design info/mockups.

*/

Structural.Views.Autocomplete = Support.CompositeView.extend({
  className: 'autocomplete',
  initialize: function(options) {
    this._dictionary = options.dictionary;
    this._blacklist = options.blacklist;
    this._addSelectionToBlacklist = options.addSelectionToBlacklist;
    this._property = options.property;

    this._optionsView = new Structural.Views.AutocompleteOptions({
      collection: this._dictionary,
      blacklist: this._blacklist,
      property: this._property
    });

    this._inputView = new Structural.Views.AutocompleteInput({
    });

    this._wireViewEvents(this._optionsView, this._inputView);
  },
  render: function() {
    this.appendChild(this._inputView);
    this.appendChild(this._optionsView);
    return this;
  },

  addToBlacklist: function(item) {
    this._blacklist.add(item);
    this._optionsView.addToBlacklist(item);
  },

  removeFromBlacklist: function(item) {
    this._blacklist.remove(item);
    this._optionsView.removeFromBlacklist(item);
  },

  cancel: function() {
    this._optionsView.clear();
    this._inputView.clear();
  },

  _wireViewEvents: function(optionsView, inputView) {
    inputView.on('textChanged', optionsView.updateOptionsList, optionsView);
    inputView.on('up', optionsView.targetUp, optionsView);
    inputView.on('down', optionsView.targetDown, optionsView);
    inputView.on('select', this._select, this);
    optionsView.on('select', this._select, this);
    Structural.on('clickAnywhere', this._cancelIfClickOff, this);
  },

  _select: function() {
    var selected = this._optionsView.target();
    this._optionsView.clear();
    this._inputView.clear();

    if (this._addSelectionToBlacklist) {
      this.addToBlacklist(selected);
    }

    this.trigger('selected', selected);
  },

  _cancelIfClickOff: function(e) {
    var self = this;
    var target = $(e.target);
    if (!target.is(this.$el) &&
        _.filter(target.parents(), function(x) { return $(x).is(self.$el); }).length === 0) {
      this.cancel();
    }
  }
});
