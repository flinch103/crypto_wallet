import  I18x  from '../util/i18x';
import  httpRequest  from '../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

resetPasswordValidation();

// User signup form validation
function resetPasswordValidation(){
    $("#change_password_form").validate({
        rules: {
            "user[password]": {
                required: true,
                minlength: 6
            },
            "user[password_confirmation]": {
                required: true,
                minlength: 6,
                equalTo: "#user_password"
            }
        },
        messages: {
            "user[password]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'password'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Password', minChar: '6'})
            },
            "user[password_confirmation]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'password confirmation'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Password confirmation', minChar: '6'}),
                equalTo: I18x.T(localeMsg.confirmationMatch, {displayLabel: 'Password confirmation'})
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
    } );
}