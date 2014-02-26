Structural.Views.Toast = Backbone.View.extend({
  className: function() {
    var classes = 'toast';

    if (this.description) {
      classes += ' toast-' + description.state;
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

  show: function(description) {
    this.description = description;
    this.render();

    if (this.description.autoDismiss) {
      setTimeout(_.bind(this.hide, this), this.description.duration);
    }
  },
  hide: function() {
    this.$el.addClass('hidden');
  }
});
