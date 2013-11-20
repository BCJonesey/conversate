// This should disable body srolling on iOS devices, but allow scrolling on elements with .ui-scrollable.

 $('body').on('touchmove', function (e) {
         if (!$('.ui-scrollable').has($(e.target)).length) e.preventDefault();
 });
