import 'package:agitation/models/admin.dart';

class Message {
  int isAdmin;
  String text;
  int chatId;
  Admin? admin;
  DateTime? createdAt;

  Message({
    required this.isAdmin,
    required this.text,
    required this.chatId,
    required this.admin,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> data) {
    // print(data);

    checkIsAdmin() => data['user'] != null ? 1 : 0;

    //time = "created_at": "2023-07-12T09:58:37.000000Z"
    DateTime _timePretty({required String time}) => DateTime.parse(time).toLocal();

    return Message(
      isAdmin: checkIsAdmin(),
      text: data['text'],
      chatId: data['chat_id'].runtimeType != int ? int.parse(data['chat_id']) : data['chat_id'],
      createdAt: _timePretty(time: data['created_at']),
      admin: checkIsAdmin() == 1
          ? Admin(
              id: data['user']['id'],
              name: data['user']['name'],
              email: data['user']['email'],
              image: data['user']['image'],
            )
          : null,
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
