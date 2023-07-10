class Client {
  int? id;
  String? title;
  int? statusId;
  String? phone;
  String? comment;
  int? workerId;
  int? taskId;
  String? createdAt;
  String? updatedAt;

  Client({
    this.id,
    this.title,
    this.statusId,
    this.phone,
    this.comment,
    this.workerId,
    this.taskId,
    this.createdAt,
    this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        title: json["title"],
        statusId: json["status_id"],
        phone: json["phone"],
        comment: json["comment"],
        workerId: json["worker_id"],
        taskId: json["task_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

/*
  "id": 1,
  "title": "title",
  "status_id": "2",
  "phone": "123546",
  "comment": "comment",
  "worker_id": "3",
  "task_id": "1",
  "created_at": "2023-06-22T14:00:33.000000Z",
  "updated_at": "2023-06-22T14:00:33.000000Z"
*/
