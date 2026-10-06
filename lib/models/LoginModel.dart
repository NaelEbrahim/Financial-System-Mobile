class LoginModel {
  final String access_token;

  final String refresh_token;

  LoginModel(this.access_token, this.refresh_token);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    json = json['message'];
    return LoginModel(json['accesstoken'], json['refreshtoken']);
  }
}
