(function () {
  $(function reflow () {
    $('.container').css('top', $('.nav-header').outerHeight());
    var cnvInfoHeight = $('.cnv-info').outerHeight();
    var shortFormHeight = $('#short-form-compose').outerHeight();
    $('#thread').css('top',cnvInfoHeight).ccc('bottom',shortFormHeight);

    $('.reflow').click(reflow);
  });
})();
