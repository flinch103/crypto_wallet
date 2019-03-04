const LOCALE = {
  'AUTH' : {
    billLimit : 'Cannot add past bills for more than 12 months.',
    errRequired : 'Please enter %{displayLabel}.',
    errAlreadyAdded : '%{displayLabel} already added.',
    errSelect : 'Please select %{displayLabel}.',
    errChoose : 'Please choose %{displayLabel}.',
    errValid : 'Please enter valid %{displayLabel}.',
    minLength : '%{displayLabel} should be at least %{minChar} chars long.',
    maxLength : '%{displayLabel} cannot be more than %{maxChar} chars.',
    errValid : 'Please enter valid %{displayLabel}.',
    uniqField : '%{displayLabel} already in use. Try another.',
    confirmationMatch : "%{displayLabel} didn't match.",
    lettersOnly : 'Please enter only letters.',
    letter_and_space_only: "Letters and spaces only please",
    noSpace : "Please don't enter space",
    firstName: 'first name',
    lastName: 'last name',
    email : 'email',
    password : 'password',
    atLeast6Character: 'at least 6 characters.',
    passwordComplexity: 'Password contains atleast one lowercase character, one uppercase character, one digit and one special character',
    current_password_is_invalid: 'Current password is invalid',
    nameFormat : "%{displayLabel} format is incorrect",
    avatar_error: "Please upload a valid JPG, JPEG, PNG format image",
    avatar_success: "Profile picture uploaded successfully"
  },
  'DASHBOARD': {},
  'CONSTANT': {
    // timeout in milliseconds
    timeout: 2000
  },
  'PROPERTY' : {
    errSelect: 'Please Select Subcategory',
    property_details_updated: 'Property details updated successfully',
    energy_data_updated: 'Energy data updated successfully',
    checklist_updated: 'Checklist updated successfully'
  }
};

export {LOCALE} ;