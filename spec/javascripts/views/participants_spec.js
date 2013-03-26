describe("Participants", function() {
  var participants;

  beforeEach(function() {
    participants = [
      { name: "Sharon Jones",
        id: 1
      },
      { name: "The Dap Kings",
        id: 2
      }
    ]
  });

  describe("token view", function() {
    it("has a name and a close button", function() {
      var model = new Structural.Models.Participant(participants[0]);
      var view = new Structural.Views.Participant({model: model});
      view.render();

      expect(view.$el.text()).toMatch(/Sharon Jones/);
      expect(view.$('.participant-remove').length).toEqual(1);
    })
  });
});
