// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  var carousel = $(".carousel");
  var horses = $(".horse");
  var index = 0;
  var next = function() {
    var horse = $(horses[index]);
    horse.fadeIn(1000);
    var pic = horse.find("img");
    if (pic.innerWidth() < horse.innerWidth()) {
      pic.css("width", horse.innerWidth());
    }
    var dx = pic.innerWidth() - horse.innerWidth();
    var dy = pic.innerHeight() - horse.innerHeight();
    var startX = Math.random() * dx;
    var endX = Math.random() * dx;
    var startY = Math.random() * dy;
    var endY = Math.random() * dy;

    pic.css("left", "-" + startX + "px");
    pic.css("top", "-" + startY + "px");

    pic.animate({
      top: -endY,
      left: -endX
    }, 10000, "linear")
    setTimeout(function() {
      index = (index + 1) % horses.length;
      setTimeout(next, 0);
      horse.fadeOut(1000);
    }, 9000)
  };

  next();
})
