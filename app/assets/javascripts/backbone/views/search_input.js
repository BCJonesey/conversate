Structural.Views.SearchInput = Support.CompositeView.extend({
  className: 'search-input form',
  template: JST.template('search/input'),
  initialize: function(options) {
    this._query = options.query || "";
  },
  render: function() {
    this.$el.html(this.template({
      query: this._query
    }));
    this._input = this.$('input');
  },
  events: {
    'keyup input': 'queryChanged'
  },

  queryChanged: _.debounce(function() {
    this._query = this._input.val();
    this.trigger('queryChanged', this._query);
  }, 300),

  focus: function() {
    this._input.focus();
  },

  clear: function() {
    this._query = '';
    this._input.val('');
  }
});
