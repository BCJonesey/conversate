// This should disable body srolling on iOS devices, but allow scrolling on elements with .ui-scrollable.

 // $('body').on('touchmove', function (e) {
 //         if (!$('.ui-scrollable').has($(e.target)).length) e.preventDefault();
 // });


// This should disable body srolling on iOS devices, but allow scrolling on elements with .ui-scrollable.

//$(document).on("touchmove", function(evt) { evt.preventDefault() });
//$(document).on("touchmove", ".ui-scrollable", function(evt) { evt.stopPropagation() });


var selScrollable = '.ui-scrollable';

// Uses document because document will be topmost level in bubbling

$(document).on('touchmove',function(e){
  e.preventDefault();
});

// Uses body because jQuery on events are called off of the element they are
// added to, so bubbling would not work if we used document instead.

$('body').on('touchstart', selScrollable, function(e) {
  if (e.currentTarget.scrollTop === 0) {
    e.currentTarget.scrollTop = 1;
  } else if (e.currentTarget.scrollHeight === e.currentTarget.scrollTop + e.currentTarget.offsetHeight) {
    e.currentTarget.scrollTop -= 1;
  }
});

$('body').on('touchmove', selScrollable, function(e) {
    // Only block default if internal div contents are large enough to scroll
    // Warning: scrollHeight support is not universal. (http://stackoverflow.com/a/15033226/40352)
    if($(this)[0].scrollHeight > $(this).innerHeight()) {
        e.stopPropagation();
    }
});
