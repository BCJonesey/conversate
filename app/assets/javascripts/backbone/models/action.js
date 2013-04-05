Structural.Models.Action = Backbone.Model.extend({
  initialize: function(attributes, options) {
    // TODO: Figure out where the current user is stored, update this.isOwnAction.
    this.set('isOwnAction', false);

    if (this.get('user')) {
      this.set('user', new Structural.Models.Participant(this.get('user')));
    }

    if (this.get('type') == 'update_users' &&
        this.get('added') &&
        this.get('removed')) {
      this.set('added', new Structural.Collections.Participants(this.get('added')));
      this.set('removed', new Structural.Collections.Participants(this.get('removed')));
    }
  },
  focus: function() {
    this.set('is_current', true);
  },
  humanizedTimestamp: (function() {
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug',
                  'Sep', 'Oct', 'Nov', 'Dec'];
    return function(relativeTo) {
      var stamp = new Date(this.get('timestamp'));

      if (stamp.getFullYear() == relativeTo.getFullYear() &&
          stamp.getMonth() == relativeTo.getMonth() &&
          stamp.getDate() == relativeTo.getDate()) {
        var hours = stamp.getHours();
        var meridian = 'am';
        if (hours >= 12) {
          meridian = 'pm';
          hours -= 12;
        }

        if (hours == 0) {
          hours = 12;
        }

        var minutes = stamp.getMinutes();
        if (minutes < 10) {
          minutes = '0' + minutes;
        }

        return hours + ':' + minutes + ' ' + meridian;
      }
      else if (stamp.getFullYear() == relativeTo.getFullYear()) {
        return months[stamp.getMonth()] +  ' ' + stamp.getDate();
      }
      else {
        return (stamp.getMonth() + 1) + '/' + stamp.getDate() + '/' + (stamp.getFullYear() + '').substring(2);
      }
    };
  })()
});
