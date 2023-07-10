class Image {
  int id;
  String image;
  int workerId;
  int taskId;
  String createdAt;
  String updatedAt;

  Image({required this.id, required this.image, required this.workerId, required this.taskId, required this.createdAt, required this.updatedAt});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      image: json["image"],
      workerId: json["worker_id"],
      taskId: json["task_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}

/*
{
  "id": 1,
  "image": "1687434957.jpg",
  "worker_id": "1",
  "task_id": "1",
  "created_at": "2023-06-22T11:55:57.000000Z",
  "updated_at": "2023-06-22T11:55:57.000000Z"
},
*/
