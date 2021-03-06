document.addEventListener("turbolinks:load", function() {
  $('#response_email').change(function () {
    $(this).removeClass('is-valid').removeClass('is-invalid');
    if($(this).val()) {
      target = $(this)
      $.getJSON( $(this).attr('data-verify-email-url'), {'email_address': $(this).val()}, function( data, status ) {
        if(data.verified) {
          target.addClass('is-valid')
        } else {
          target.addClass('is-invalid')
        }
      })
    }
  });
});