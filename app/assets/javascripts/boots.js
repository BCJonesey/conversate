$('.btn.dropdown-toggle').click(function (e) {
  e.stopPropagation();
  $(this).toggleClass('active').siblings().toggleClass('hidden');
  $('html').click(function () {
    $('.btn.dropdown-toggle').removeClass('active');
    $('.dropdown-menu, .popover').addClass('hidden');
  });
});