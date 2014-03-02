/* Takes the name of a property on a model (as a string) and returns an object
   suitable for mixing into that model (via _.extend) that calculates a human-
   friendly timestamp for that property.

   The property given should return a number suitable for passing into
   `new Date()`. */
Support.HumanizedTimestamp = function(property, globalOptions) {
  globalOptions = globalOptions || {};
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
                'Sep', 'Oct', 'Nov', 'Dec'];

  var hourMinuteStamp = function(date) {
    var hours = date.getHours();
    var meridian = 'am';
    if (hours >= 12) {
      meridian = 'pm';
      hours -= 12;
    }

    if (hours === 0) {
      hours = 12;
    }

    var minutes = date.getMinutes();
    if (minutes < 10) {
      minutes = '0' + minutes;
    }

    return hours + ':' + minutes + ' ' + meridian;
  };

  var monthDateStamp = function(date) {
    return months[date.getMonth()] + ' ' + date.getDate();
  };

  var yearMonthDateStamp = function(date) {
    return (date.getMonth() + 1) + '/' +
           date.getDate() + '/' +
           (date.getFullYear() + '').substring(2);
  };

  var stampWithHourMinuteIfOption = function(date, stampFn, options) {
    var stamp = stampFn(date);
    if (options.alwaysIncludeHourMinute) {
      stamp += ' - ' + hourMinuteStamp(date);
    }
    return stamp;
  }

  return {
    humanizedTimestamp: function(relativeTo, options) {
      relativeTo = relativeTo || new Date();
      options = _.defaults(options || {}, globalOptions);
      var date = new Date(this.get(property));

      if(date.getFullYear() === relativeTo.getFullYear() &&
         date.getMonth() === relativeTo.getMonth() &&
         date.getDate() === relativeTo.getDate()) {
        return hourMinuteStamp(date);
      }
      else if (date.getFullYear() === relativeTo.getFullYear()) {
        return stampWithHourMinuteIfOption(date, monthDateStamp, options);
      }
      else {
        return stampWithHourMinuteIfOption(date, yearMonthDateStamp, options);
      }
    }
  };
}
