class NewUserModel {
  String name;
  String email;
  String phone;
  String code;
  String countryCode;
  String password;
  int gender;

  String verificationId;

  int resendToken;

  NewUserModel({
    this.name,
    this.email,
    this.phone,
    this.code,
    this.countryCode,
    this.password,
    this.gender,
  });
}
