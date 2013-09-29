Structural.Views.FaviconAndTitle = Support.CompositeView.extend({
  initialize: function(options) {
    options = options || {};
    this._folders = options.folders;
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
    var totalUnreadConversations = this._folders.reduce(function(sum, folder) {
      return sum + folder.unreadConversationCount();
    }, 0);
    var preamble = '';
    if (totalUnreadConversations > 0) {
      preamble = '(' + totalUnreadConversations + ') ';

      // Also want to swap to the unread icon.
      iconName = 'watercooler-unread';
    }

    // Firefox won't change the icon unless we make an actual new tag.
    var newFavicon = this._favicon.clone();
    newFavicon.attr('href', '/assets/' + iconName + '.png');
    this._favicon.replaceWith(newFavicon);
    this._favicon = newFavicon;
    this._title.text(preamble + title);
  }
});
