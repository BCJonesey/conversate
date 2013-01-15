$('.btn.dropdown-toggle').click(function (e) {
  e.stopPropagation();
  $(this).toggleClass('active').siblings().toggleClass('hidden');
  $('html').on('click', function () {
    $('.btn.dropdown-toggle').removeClass('active');
    $('.dropdown-menu, .popover').addClass('hidden');
    $('html').off('click');
  });
});
