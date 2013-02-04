(function() {
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug',
                'Sep', 'Oct', 'Nov', 'Dec'];

  var humanizedDate = function(date) {
    var today = new Date();

    if (date.getFullYear() == today.getFullYear() &&
        date.getMonth() == today.getMonth() &&
        date.getDate() == today.getDate()) {
      var hours = date.getHours();
      var meridian = 'am';
      if (hours >= 12) {
        meridian = 'pm';
        hours -= 12;
      }

      if (hours == 0) {
        hours = 12;
      }

      var minutes = date.getMinutes();
      if (minutes < 10) {
        minutes = '0' + minutes;
      }

      return hours + ':' + minutes + ' ' + meridian;
    }
    else if (date.getFullYear() == today.getFullYear()) {
      return months[date.getMonth()] + ' ' + date.getDate();
    }
    else {
      return (date.getMonth() + 1) + '/' + date.getDate() + '/' + (date.getFullYear() + '').substring(2);
    }
  };

  $(function() {
    $('.unfilled-timestamp').each(function(index, stamp) {
      stamp = $(stamp);
      var date = new Date(parseInt(stamp.attr('data-timestamp'), 10));
      stamp.text(humanizedDate(date));
      stamp.removeClass('unfilled-timestamp');
    });
  });
})();
