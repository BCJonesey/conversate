describe("Topic list", function() {
  var topics, collection, view;

  beforeEach(function() {
    topics = [
      { name: "Conversations", id: 1 },
      { name: "Structural", id: 2 },
      { name: "Chatter", id: 3 }
    ];
    collection = new Structural.Collections.Topics(topics);
    view = new Structural.Views.Topics({collection: collection});
    view.render();
  });

  it("has an entry for each topic", function() {
    expect(view.$('.tpc').length).toEqual(3);
  });

  it("has each topic's name", function() {
    expect(view.$('.tpc')[0].innerText.trim()).toEqual(topics[0].name);
    expect(view.$('.tpc')[1].innerText.trim()).toEqual(topics[1].name);
    expect(view.$('.tpc')[2].innerText.trim()).toEqual(topics[2].name);
  });

  it("has a top-level class", function() {
    expect(view.el.className).toEqual("tpc-list");
  });

  it("has a topic hint tag", function() {
    expect(view.$('.tpc-hint').length).toEqual(1);
  })
});
