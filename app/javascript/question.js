$(function(){
  $('#answer-type-select').change(function(){
    $( "select option:selected" ).each(function() {
      if($( this ).text().toLowerCase().startsWith('multiple choice')) {
        $('#choices-group').removeClass('d-none');
      } else {
        $('#choices-group').addClass('d-none');
      }
      if($( this ).text().toLowerCase() == 'score') {
        $('#slider-group').removeClass('d-none');
      } else {
        $('#slider-group').addClass('d-none');
      }
    });
  });
  $(".js-range-slider").ionRangeSlider({skin: "round"});
});

document.addEventListener("turbolinks:load", function() {

  $("#questions").sortable({
    update: function(e, ui) {
      Rails.ajax({
        url: $(this).data("url"),
        type: "PATCH",
        data: $(this).sortable('serialize'),
      });
    }
  });
});