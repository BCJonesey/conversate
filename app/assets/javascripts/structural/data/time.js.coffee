monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
              'Oct', 'Nov', 'Dec']

Time = {
  isSameDay: (dateOne, dateTwo) ->
    dateOne.getFullYear() == dateTwo.getFullYear() and
    dateOne.getMonth() == dateTwo.getMonth() and
    dateOne.getDate() == dateTwo.getDate()

  isSameYear: (dateOne, dateTwo) ->
    dateOne.getFullYear() == dateTwo.getFullYear()

  hourMinuteTimestr: (date) ->
    hours = date.getHours()

    meridian = 'am'
    if hours >= 12
      meridian = 'pm'
      hours -= 12

    if hours == 0
      hours = 12

    minutes = date.getMinutes()
    if minutes < 10
      minutes = "0#{minutes}"

    "#{hours}:#{minutes} #{meridian}"

  monthDateTimestr: (date) ->
    month = monthNames[date.getMonth()]
    dayOfMonth = date.getDate()

    "#{month} #{dayOfMonth}"

  yearMonthDateTimestr: (date) ->
    monthNum = date.getMonth() + 1
    dayOfMonth = date.getDate()
    twoDigitYear = "#{date.getFullYear()}".substring(2)

    "#{monthNum}/#{dayOfMonth}/#{twoDigitYear}"

  timestrWithHourMinuteIfOptions: (date, strFn, options) ->
    timestr = strFn(date)
    if options.alwaysIncludeHourMinute
      "#{timestr} - #{Time.hourMinuteTimestr(date)}"
    else
      timestr

  timestampToHumanizedTimestr: (timestamp, relativeTo, options) ->
    relativeTo = if relativeTo then new Date(relativeTo) else new Date()
    options = options || {}
    date = new Date(timestamp)

    if options.onlyIncludeHourMinute
      Time.hourMinuteTimestr(date)
    else if Time.isSameDay(date, relativeTo)
      Time.hourMinuteTimestr(date)
    else if Time.isSameYear(date, relativeTo)
      Time.timestrWithHourMinuteIfOptions(date, Time.monthDateTimestr, options)
    else
      Time.timestrWithHourMinuteIfOptions(date, Time.yearMonthDateTimestr, options)
}

Structural.Data.Time = Time
