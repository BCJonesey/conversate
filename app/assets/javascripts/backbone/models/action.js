Structural.Models.Action = Backbone.Model.extend({
  initialize: function(attributes, options) {
    this.inflateExtend(this.attributes);
  },
  parse: function (response, options) {
    return this.inflateReturn(response);
  },

  inflateAttributes: function(attrs) {
    if (attrs.user) {
      attrs.user = this.inflate(Structural.Models.Participant, attrs.user);
    }

    if (_.contains(['update_users', 'update_folders', 'update_viewers'], attrs.type)) {
      var collection = this.chooseType({
        update_users: Structural.Collections.Participants,
        update_folders: Structural.Collections.Folders,
        update_viewers: Structural.Collections.Participants
      }, attrs.type);

      attrs.added = this.inflate(collection, attrs.added);
      attrs.removed = this.inflate(collection, attrs.removed);
    }

    if (attrs.type == 'update_folders') {
      attrs.addedViewers = this.inflate(Structural.Collections.Participants, attrs.addedViewers);
    }

    if (attrs.type === 'move_message') {
      attrs.from = this.inflate(Structural.Models.Conversation, attrs.from);
    }

    if (attrs.text) {
      attrs.enhanced_text = Support.TextEnhancer.enhance(_.escape(attrs.text));
    }

    if (attrs.full_text) {
      attrs.enhanced_full_text = Support.TextEnhancer.enhance(_.escape(attrs.full_text));
    }

    if (attrs.type === 'email_delivery_error') {
      attrs.recipient = this.inflate(Structural.Models.Participant,
                                     attrs.recipient);
      attrs.message = this.inflate(Structural.Models.Action, attrs.message);
    }

    return attrs;
  },

  focus: function() {
    this.set('focused', true);
  },
  unfocus: function() {
    this.set('focused', false);
  },
  delete: function(user) {
    this.set('type', 'deletion');
    this.set('user', user);
  },
  mine: function(){
    this.set('isOwnAction', true);
  },
  isUnread: function(mostRecentEventViewed) {
    if (this.get('user').id === Structural._user.id) {
      return false;
    }
    return this.get('timestamp') > mostRecentEventViewed;
  },
  markRead: function() {
    this.set('is_unread', false);
  },
  markUnread: function() {
    this.set('is_unread', true);
  },
  isFocused: function() {
    return this.get('focused');
  },
  isMessageType: function() {
    return _.contains(['message', 'email_message'], this.get('type'));
  },
  isUpdateFoldersWithoutAdditions: function() {
    if (this.get('type') != 'update_folders' || this.get('addedViewers').length > 0) {
      return false;
    }
    return true;
  },
  followOnTimeout: 5 * 60 * 1000,
  isFollowOn: function(previousAction) {
    var timeSincePrevious = this.get('timestamp') - previousAction.get('timestamp');
    return previousAction.get('type') === 'message' &&
           this.get('type') === 'message' &&
           previousAction.get('user').id === this.get('user').id &&
           this.get('text').indexOf('\n') < 0 &&
           timeSincePrevious <= this.followOnTimeout;
  },
  isInDifferentTimeBucket: function(previousAction) {
    return Math.floor(this.get('timestamp') / this.followOnTimeout) != Math.floor(previousAction.get('timestamp') / this.followOnTimeout);
  },
  followOn: function() {
    this.set('followOn', true);
  },
  followOnLongTerm: function() {
    this.set('followOnLongTerm', true);
  },
  textSnippet: function(length) {
    var text = this.escape('text');
    if (length >= text.length) {
      return text;
    } else {
      return text.substring(0, length) + '&hellip;';
    }
  }
});

_.extend(Structural.Models.Action.prototype,
         Support.HumanizedTimestamp('timestamp',
                                    { alwaysIncludeHourMinute: true }));
_.extend(Structural.Models.Action.prototype, Support.InflatableModel);
