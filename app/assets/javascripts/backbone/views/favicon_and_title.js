Structural.Views.FaviconAndTitle = Support.CompositeView.extend({
  initialize: function(options) {
    options = options || {};
    this._topics = options.topics;
    this._favicon = $('head link[rel="icon"]');
    this._title = $('head title');
  },
  render: function() {
    var totalUnreadConversations = this._topics.reduce(function(sum, topic) {
      return sum + topic.unreadConversationCount();
    }, 0);
    var iconName = 'watercooler';
    var title = 'Water Cooler';

    if (/localhost/.test(window.location.host)) {
      title = 'meo aquam frigideorem';
    }
    else if (/kuhltank/.test(window.location.host)) {
      title = 'Kuhltank';
    }

    this._favicon.attr('href', '/assets/' + iconName + '.png');
    this._title.text(title);
  }
});
