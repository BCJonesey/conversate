/* Takes the name of a property on a model (as a string) and returns an object
   suitable for mixing into that model (via _.extend) that calculates a human-
   friendly timestamp for that property.

   The property given should return a number suitable for passing into
   `new Date()`. */
Support.HumanizedTimestamp = function(property) {
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
                'Sep', 'Oct', 'Nov', 'Dec'];
  return {
    humanizedTimestamp: function(relativeTo) {
      relativeTo = relativeTo || new Date();
      var date = new Date(this.get(property));

      if(date.getFullYear() === relativeTo.getFullYear() &&
         date.getMonth() === relativeTo.getMonth() &&
         date.getDate() === relativeTo.getDate()) {
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
      }
      else if (date.getFullYear() === relativeTo.getFullYear()) {
        return months[date.getMonth()] + ' ' + date.getDate();
      }
      else {
        return (date.getMonth() + 1) + '/' + date.getDate() + '/' + (date.getFullYear() + '').substring(2);
      }
    }
  };
}
