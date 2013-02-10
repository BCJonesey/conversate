function editCnvTitle(){
  $('.cnv-info-title-input').removeAttr('readonly').addClass('editing');
  $('.cnv-info-title-actions').addClass('hidden');
  $('.cnv-info-title-save-actions').removeClass('hidden');
};

function saveCnvTitle (){
  $('.cnv-info-title-input').attr('readonly','readonly').removeClass('editing');
  $('.cnv-info-title-actions').removeClass('hidden');
  $('.cnv-info-title-save-actions').addClass('hidden');
};

$('.cnv-info-title-edit').click(editCnvTitle);
$('.cnv-info-title-save').click(saveCnvTitle);


function editCnvParticipants(){
  $('.cnv-info-particiapnts-input').removeAttr('readonly').addClass('editing');
  $('.cnv-info-particiapnts-actions').addClass('hidden');
  $('.cnv-info-particiapnts-save-actions').removeClass('hidden');
};

function saveCnvParticipants (){
  $('.cnv-info-particiapnts-input').attr('readonly','readonly').removeClass('editing');
  $('.cnv-info-particiapnts-actions').removeClass('hidden');
  $('.cnv-info-particiapnts-save-actions').addClass('hidden');
};

$('.cnv-info-particiapnts-edit').click(editCnvParticiapnts);
$('.cnv-info-particiapnts-save').click(saveCnvParticiapnts);
