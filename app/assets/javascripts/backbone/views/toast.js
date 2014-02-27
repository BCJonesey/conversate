Structural.Views.Toast = Backbone.View.extend({
  className: function() {
    var classes = 'toast-wrap';

    if (this.description) {
      classes += ' toast-' + this.description.state;
    } else {
      classes += ' hidden';
    }

    return classes;
  },
  template: JST.template('structural/toast'),
  initialize: function(options) {
  },
  render: function() {
    if (this.description) {
      this.$el.html(this.template(this.description));
      this.el.className = this.className();
    }

    return this;
  },
  events: {
    'click .toast-refresh': 'refresh'
  },

  show: function(description) {
    this.description = description;
    this.render();
  },
  hide: function() {
    this.$el.addClass('hidden');
  },
  refresh: function(e) {
    if (e) { e.preventDefault(); }

    window.location.reload(true);
  }
});
