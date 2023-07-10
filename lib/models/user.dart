class User {
  int id;
  String fullName;
  String username;
  String password;
  int jobTitleId;
  String token;
  int? groupId;

  User({required this.id, required this.fullName, required this.username, required this.password, required this.token, required this.jobTitleId, required this.groupId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'username': username,
        'password': password,
        "group_id": groupId,
        'job_title': jobTitleId,
        'token': token,
      };
}
