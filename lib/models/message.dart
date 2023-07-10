class Message {
  int id;
  int isAdmin;
  String text;
  String chatId;
  String? deletedAt;
  String createdAt;
  String updatedAt;

  Message({
    required this.id,
    required this.isAdmin,
    required this.text,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt = null,
  });

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
      id: data['id'],
      isAdmin: data['is_admin'],
      text: data['text'],
      chatId: data['chat_id'],
      deletedAt: data['deleted_at'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "is_admin": isAdmin,
      "text": text,
      "chat_id": chatId,
      "deleted_at": deletedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

/*
{
  "id": 425,
  "is_admin": 0,
  "text": "xuwnudbek266",
  "chat_id": "6",
  "deleted_at": null,
  "created_at": "2023-07-10T11:12:57.000000Z",
  "updated_at": "2023-07-10T11:12:57.000000Z"
},

*/
