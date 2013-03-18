describe("Topic list", function() {
  it("has an entry for each topic", function() {
    var topics = [
      { name: "Conversations", id: 1 },
      { name: "Structural", id: 2 },
      { name: "Chatter", id: 3 }
    ];
    var tpcCollection = new Structural.Collections.Topics(topics);
    var view = new Structural.Views.Topics({collection: tpcCollection});
    view.render();

    expect(view.$('.tpc').length).toEqual(3);
  });
});
