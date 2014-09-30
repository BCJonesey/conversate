describe 'Time', ->
  {timestampToHumanizedTimestr} = Structural.Data.Time

  beforeEach ->
    @rightNow = new Date(2014, 8, 27, 18, 7).valueOf()
    @earlierToday = new Date(2014, 8, 27, 9, 38).valueOf()
    @earlierThisYear = new Date(2014, 7, 28, 15, 3).valueOf()
    @beforeThisYear = new Date(2013, 11, 6, 15, 46).valueOf()
    @midnightToday = new Date(2014, 8, 27, 0, 0).valueOf()
    @noonToday = new Date(2014, 8, 27, 12, 0).valueOf()

  it 'shows a date today in hour:minute format', ->
    expect(timestampToHumanizedTimestr(@earlierToday, @rightNow)).toBe('9:38 am')

  it 'shows a date this year in month day format', ->
    expect(timestampToHumanizedTimestr(@earlierThisYear, @rightNow)).toBe('Aug 28')

  it 'shows a date before this year in month/day/year format', ->
    expect(timestampToHumanizedTimestr(@beforeThisYear, @rightNow)).toBe('12/6/13')

  it 'shows a time at midnight correctly', ->
    expect(timestampToHumanizedTimestr(@midnightToday, @rightNow)).toBe('12:00 am')

  it 'shows a time at noon correctly', ->
    expect(timestampToHumanizedTimestr(@noonToday, @rightNow)).toBe('12:00 pm')

  it 'only shows the hour and minute if passed onlyIncludeHourMinute', ->
    options = {onlyIncludeHourMinute: true}
    expect(timestampToHumanizedTimestr(@earlierThisYear, @rightNow, options))
      .toBe('3:03 pm')

  it 'also shows the hour and minute if passed alwaysIncludeHourMinute', ->
    options = {alwaysIncludeHourMinute: true}
    expect(timestampToHumanizedTimestr(@earlierThisYear, @rightNow, options))
      .toBe('Aug 28 - 3:03 pm')
