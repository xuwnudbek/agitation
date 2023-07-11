class Message {
  int isAdmin;
  String text;
  int chatId;

  Message({
    required this.isAdmin,
    required this.text,
    required this.chatId,
  });

  factory Message.fromJson(Map<String, dynamic> data) {
    print(data['is_admin'].runtimeType.runtimeType);

    checkIsAdmin(isAdmin) {
      if (isAdmin.runtimeType == int) return isAdmin;
      if (isAdmin.runtimeType == bool) return isAdmin ? 1 : 0;
    }

    return Message(
      isAdmin: checkIsAdmin(data['is_admin']),
      text: data['text'],
      chatId: data['chat_id'].runtimeType != int ? int.parse(data['chat_id']) : data['chat_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "is_admin": isAdmin,
      "text": text,
      "chat_id": chatId,
    };
  }
}


/*
{
  "data": {
    "text": "asdasdasdasd 123123123",
    "is_admin": 1,
    "chat_id": 1,
    "worker_id": 1
  }
}
*/
