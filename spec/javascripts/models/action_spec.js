describe("Action model", function() {
  it("can compute human-friendly timestamps", function() {
    // Note that the month in this constructor is 0-indexed, unlike the
    // other fields.
    var today = new Date(2013, 3, 21);
    var sameDay = new Date(2013, 3, 21, 14, 30);
    var sameYear = new Date(2013, 0, 14);
    var differentYear = new Date(2011, 2, 28);

    var sameDayAction = new Structural.Models.Action({timestamp: sameDay.getTime()});
    var sameYearAction = new Structural.Models.Action({timestamp: sameYear.getTime()});
    var differentYearAction = new Structural.Models.Action({timestamp: differentYear.getTime()});

    expect(sameDayAction.humanizedTimestamp(today)).toEqual('2:30 pm');
    expect(sameYearAction.humanizedTimestamp(today)).toEqual('Jan 14');
    expect(differentYearAction.humanizedTimestamp(today)).toEqual('3/28/11');
  });
});
