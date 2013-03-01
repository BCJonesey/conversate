// Editing the title
function cnvTitleFoucs(e){
  e.preventDefault();
  e.stopPropagation();
  $('.cnv-info-title-input').focus();

};

function cnvTitleEdit(e){
  currentTitle = $('.cnv-info-title-input').val();
  $('.cnv-info-title').addClass('editing');
  $('.cnv-info-title-input').removeAttr('readonly');
  $('.cnv-info-title-actions').addClass('hidden');
  $('.cnv-info-title-save-actions').removeClass('hidden');

  $('.cnv-info-title').on('click',cnvTitleFoucs);

  // Bind a click away to cancel the operation
  $(document).on('click',cnvTitleLock);
  $('.cnv-info-title-input').focus().val(currentTitle);

  return(currentTitle);
};



function cnvTitleLock(){
  $('.cnv-info-title').removeClass('editing');
  $('.cnv-info-title-input').attr('readonly','readonly');
  $('.cnv-info-title-actions').removeClass('hidden');
  $('.cnv-info-title-save-actions').addClass('hidden');

  // unbind the click away
  $(document).off('click',cnvTitleLock);
  $('.cnv-info-title').off('click',cnvTitleFoucs);


  $('.cnv-info-title-input').val(currentTitle);

};



function cnvTitleSubmit (e){

  e.preventDefault();
  e.stopPropagation();

  $('.cnv-info-title form').submit();

  cnvTitleLock();

};

$('.cnv-info-title-edit').live('click',cnvTitleEdit);
// Bind the edit button to make the field editable

$('.cnv-info-title-save').live('click',cnvTitleSubmit);

// Bind the checkmark to save the info



// Participants


// function editCnvParticipants(){
//   $('.cnv-info-particiapnts-input').removeAttr('readonly').addClass('editing');
//   $('.cnv-info-particiapnts-actions').addClass('hidden');
//   $('.cnv-info-particiapnts-save-actions').removeClass('hidden');
// };

// function saveCnvParticipants (){
//   $('.cnv-info-particiapnts-input').attr('readonly','readonly').removeClass('editing');
//   $('.cnv-info-particiapnts-actions').removeClass('hidden');
//   $('.cnv-info-particiapnts-save-actions').addClass('hidden');
// };

// $('.cnv-info-particiapnts-edit').click(editCnvParticiapnts);
// $('.cnv-info-particiapnts-save').click(saveCnvParticiapnts);
