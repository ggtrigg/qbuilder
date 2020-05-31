$(function(){
  $('#answer-type-select').change(function(){
    $( "select option:selected" ).each(function() {
      if($( this ).text().toLowerCase().startsWith('multiple choice')) {
        $('#choices-group').removeClass('d-none');
      } else {
        $('#choices-group').addClass('d-none');
      }
    });
  });
});