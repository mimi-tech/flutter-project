/* This a model for the sign up form. It helps in holding the data entered by the user.
   This data can be accessed from another screen/page using an object of this class.
*  */

class SignUpFormModel {
  /* Variable declarations */
  final String? username;
  final String? email;
  final String? phone;
  final String? password;
  static String? userUIDEmailPassword;

  /* Constructor declarations */
  SignUpFormModel({
    this.username,
    this.email,
    this.phone,
    this.password,
  });
}
