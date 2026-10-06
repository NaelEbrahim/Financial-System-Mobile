class ProfileModel {
  final String firstname;

  final String lastname;

  final String email;

  final String createdAt;

  final String lastUpdatedAt;

  ProfileModel(
    this.firstname,
    this.lastname,
    this.email,
    this.createdAt,
    this.lastUpdatedAt,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    json = json['message'];
    return ProfileModel(
      json['firstname'],
      json['lastname'],
      json['email'],
      json['createdAt'],
      json['updatedAt'],
    );
  }
}
