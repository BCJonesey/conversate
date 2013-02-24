function reflow () {
    $('.container').css('top', $('.nav-header').outerHeight());
    var cnvInfoHeight = $('.cnv-info').outerHeight();
    var shortFormHeight = $('#short-form-compose').outerHeight();
    $('#thread').css('top',cnvInfoHeight).css('bottom',shortFormHeight);

    var cnvListHeaderHeight = $('#column-list .conversations-list-toolbar').outerHeight();
    $('#conversations-list').css('top', cnvListHeaderHeight + 'px');

    $('.topics').css('top',$('.topics-toolbar').outerHeight() + 'px');
};

$('.reflow').click(reflow);

$(document).ready(reflow);
// TODO: This is a sad hack.  Make it go away.
setTimeout(reflow, 500);
