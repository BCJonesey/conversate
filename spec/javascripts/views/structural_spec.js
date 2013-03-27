describe("Structural", function() {
  describe("bar", function() {
    it("has some buttons and a username", function() {
      var user = { name: "Dee Dee Ramone" };
      var model = new Structural.Models.User(user);
      var view = new Structural.Views.StructuralBar({model: model});
      view.render();

      expect(view.$('.i-text').text()).toMatch(/Water Cooler/);
      expect(view.$('.i-text').text()).toMatch(/People/);
      expect(view.$('.i-text').text()).not.toMatch(/Admin/);
      expect(view.$('.text').text()).toMatch(/Dee Dee Ramone/);

      user = { name: "Monte A. Melnick",
               is_admin: true };
      model = new Structural.Models.User(user);
      view = new Structural.Views.StructuralBar({model: model});
      view.render();

      expect(view.$('.i-text').text()).toMatch(/Water Cooler/);
      expect(view.$('.i-text').text()).toMatch(/People/);
      expect(view.$('.i-text').text()).toMatch(/Admin/);
      expect(view.$('.text').text()).toMatch(/Monte A\. Melnick/);
    })
  });
});
