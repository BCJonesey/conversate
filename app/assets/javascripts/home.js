// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  var carousel = $(".carousel");
  var horses = $(".horse");
  var index = 0;
  var next = function() {
    $(horses[index]).removeClass("riding");
    index = (index + 1) % horses.length;
    $(horses[index]).addClass("riding");
    carousel.css("width", $(horses[index]).innerWidth() + 120 + "px");
  };

  next();
  setInterval(next, 30000);
})
