Structural.Views.Autocomplete = Support.CompositeView.extend({
  className: 'autocomplete',
  initialize: function(options) {
    this._dictionary = options.dictionary;
    this._blacklist = options.blacklist;
    this._addSelectionToBlacklist = options.addSelectionToBlacklist;
    this._property = options.property;
    this._inputContainer = options.inputContainer;
    this._optionsContainer = options.optionsContainer;

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
    if (this._inputContainer) {
      this.appendChildTo(this._inputView, this._inputContainer);
    } else {
      this.appendChild(this._inputView);
    }

    if (this._optionsContainer) {
      this.appendChildTo(this._optionsView, this._optionsContainer);
    } else {
      this.appendChild(this._optionsView);
    }
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
  replaceBlacklist: function(blacklist) {
    this._blacklist = blacklist.clone();
    this._optionsView.replaceBlacklist(this._blacklist);
  },
  replaceDictionary: function(dictionary) {
    this._dictionary = dictionary;
    this._optionsView.collection = this._dictionary;
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

    this.trigger('select', selected);
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
