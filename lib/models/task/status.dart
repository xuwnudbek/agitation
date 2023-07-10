class Status {
  int id;
  String title;
  String createdAt;
  String updatedAt;

  Status({required this.id, required this.title, required this.createdAt, required this.updatedAt});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

/*
{
  "id": 1,
  "title": "Ofline sotib oladi",
  "created_at": "2023-06-22T11:14:04.000000Z",
  "updated_at": "2023-06-22T11:14:04.000000Z"
},
*/