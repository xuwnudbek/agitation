class User {
  int id;
  String fullName;
  String username;
  String password;
  int jobTitleId;
  String token;
  int? groupId;
  int status;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.token,
    required this.jobTitleId,
    required this.groupId,
    required this.status,

  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'username': username,
        'password': password,
        "group_id": groupId,
        "status": status,
        'job_title': jobTitleId,
        'token': token,
      };
}
