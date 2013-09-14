Structural.Views.FaviconAndTitle = Support.CompositeView.extend({
  initialize: function(options) {
    options = options || {};
    this._topics = options.topics;
    this._favicon = $('head link[rel="icon"]');
    this._title = $('head title');
  },
  render: function() {
    var iconName = 'watercooler';
    var title = 'Water Cooler';

    if (/localhost/.test(window.location.host)) {
      title = 'meo aquam frigideorem';
    }
    else if (/kuhltank/.test(window.location.host)) {
      title = 'Kuhltank';
    }

    // Figure out how the title should look factoring in unread conversation count.
    var totalUnreadConversations = this._topics.reduce(function(sum, topic) {
      return sum + topic.unreadConversationCount();
    }, 0);
    var preamble = '';
    if (totalUnreadConversations > 0) {
      preamble = '(' + totalUnreadConversations + ') ';
    }

    this._favicon.attr('href', '/assets/' + iconName + '.png');
    this._title.text(preamble + title);
  }
});
