Structural.Views.FaviconAndTitle = Support.CompositeView.extend({
  initialize: function(options) {
    options = options || {};
    this._topics = options.topics;
    this._favicon = $('head link[rel="icon"]');
    this._title = $('head title');
  },
  render: function() {
    var totalUnreadConversations = this._topics.reduce(function(sum, topic) {
      return sum + topic.get('unread_conversations');
    }, 0);
    var iconName = 'watercooler';
    var title = 'Water Cooler';

    if (/localhost/.test(window.location.host)) {
      title = 'meo aquam frigideorem';
    }
    else if (/kuhltank/.test(window.location.host)) {
      title = 'Kuhltank';
    }

    if (totalUnreadConversations > 0) {
      iconName = 'watercooler-unread';
      title = totalUnreadConversations + ' - ' + title;
    }

    this._favicon.attr('href', '/assets/' + iconName + '.png');
    this._title.text(title);
  }
});
