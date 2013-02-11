// Editing the title

function editCnvTitle(e){
  currentTitle = $('.cnv-info-title-input').val();
  $('.cnv-info-title').addClass('editing');
  $('.cnv-info-title-input').removeAttr('readonly');
  $('.cnv-info-title-actions').addClass('hidden');
  $('.cnv-info-title-save-actions').removeClass('hidden');

  $('.cnv-info-title').on('click',function(e){
    e.preventDefault();
    e.stopPropagation();
    $('.cnv-info-title-input').focus();
  });
  // Bind a click away to cancel the operation
  $(document).on('click',cancelCnvTitle);
  $('.cnv-info-title-input').focus();

  return(currentTitle);
};



function cancelCnvTitle(){
  $('.cnv-info-title').removeClass('editing');
  $('.cnv-info-title-input').attr('readonly','readonly');
  $('.cnv-info-title-actions').removeClass('hidden');
  $('.cnv-info-title-save-actions').addClass('hidden');

  // unbind the click away
  $(document).off('click',cancelCnvTitle);

  $('.cnv-info-title-input').val(currentTitle);

};



function saveCnvTitle (){

  $('.cnv-info-title form').submit();

  cancelCnvTitle();

};


$('.cnv-info-title-edit').on('click',editCnvTitle);
// Bind the edit button to make the field editable

$('.cnv-info-title-save').on('click',function(e){
  e.preventDefault();
  e.stopPropagation();
  saveCnvTitle();
});

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
