class User {
  int id;
  String fullName;
  String username;
  String password;
  int jobTitleId;
  String token;

  User({required this.id, required this.fullName, required this.username, required this.password, required this.token, required this.jobTitleId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'username': username,
        'password': password,
        'job_title': jobTitleId,
        'token': token,
      };
}
