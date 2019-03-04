import  I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('AUTH');
import  httpRequest  from '../util/httpRequest';

// Check if email is unique
$.validator.addMethod("unique_email", function(value, element) {
    return checkEmailUniqueness(value);
});

function checkEmailUniqueness(value){
    const formData = new FormData();
    formData.append('email', value)
    let isUnique = false
    httpRequest.post('/user_profiles/check_email_uniqueness', formData)
        .done(function(res){
        })
        .fail(function(error){
            isUnique = true
        })
    return isUnique;
}


resetPasswordValidation();
function resetPasswordValidation(){
    $("#forgot_password_form").validate({
        rules: {
            "user[email]": {
                required: true,
                unique_email: true
            }
        },
        messages: {
            "user[email]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'email'}),
                unique_email: "Email doesn't exist"
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