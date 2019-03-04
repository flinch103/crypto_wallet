import  I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('AUTH');

loginValidation();
function loginValidation(){
  $("#user_login_form").validate({
  	rules: {
      "user[username]": {
        required: true,
        minlength: 2,
        maxlength: 30
      },
      "user[password]": {
      	required: true,
        minlength: 6
      }
    },
    messages: {
      "user[username]": {
        required: I18x.T(localeMsg.errRequired, {displayLabel: 'username'}),
        minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Username', minChar: '2'}),
        maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Username', maxChar: '30'})
      },
      "user[password]": {
      	required: I18x.T(localeMsg.errRequired, {displayLabel: 'password'}),
        minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Password', minChar: '6'})
      }

    },
    errorElement: "em",
    errorPlacement: function ( error, element ) {
        // Add the `help-block` class to the error element
      error.addClass( "help-block" );
      if ( element.prop( "type" ) === "checkbox" ) {
          error.insertAfter( element.parent( "label" ) );
      } else {
          error.insertAfter( element );
      }
    },
    highlight: function ( element, errorClass, validClass ) {
      $( element ).addClass( "has-error" ).removeClass( "has-success" );
      $( element ).nextAll("#correct:first").addClass('display-none')
      $( element ).nextAll("#wrong:first").removeClass('display-none')
    },
    unhighlight: function (element, errorClass, validClass) {
      $( element ).addClass( "has-success" ).removeClass( "has-error" );
      $( element ).nextAll("#wrong:first").addClass('display-none')
      $( element ).nextAll("#correct:first").removeClass('display-none')
    }
  })
}