import 'package:agitation/models/company.dart';

class Task {
  int id;
  int? companyId;
  var groupId;
  String? date;
  String? time;
  var status;
  String? createdAt;
  String? updatedAt;
  Company? company;

  Task({
    required this.id,
    this.companyId,
    required this.groupId,
    this.date,
    this.time,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.company,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    String checkIsToday(String date) {
      DateTime dateTime = DateTime.parse(date);
      var res = dateTime.difference(DateTime.now()).inDays == 0 ? true : false;
      if (res) {
        dateTime.add(Duration(days: 1));
        return dateTime.toString().split(" ")[0];
      } else {
        return dateTime.toString().split(" ")[0];
      }
    }

    return Task(
      id: json["id"],
      companyId: json["company_id"],
      groupId: json["group_id"],
      date: checkIsToday(json["date"] ?? DateTime.now().toString()),
      time: json["time"],
      status: json["status"] == true || json["status"] == 1 || json["status"] == "1" ? 1 : 0,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      company: Company.fromJson(json["company"]),
    );
  }
}

/*
{
  "id": 5,
  "company_id": "17",
  "group_id": 14,
  "date": "2023-06-21",
  "status": null,
  "created_at": "2023-06-21T07:51:39.000000Z",
  "updated_at": "2023-06-21T07:51:39.000000Z",
  "company": {
      "id": 17,
      "title": "TATU Fergana",
      "address": "fargona 23",
      "latitude": null,
      "longitude": null,
      "created_at": "2023-06-16T11:47:01.000000Z",
      "updated_at": "2023-06-16T13:16:22.000000Z"
  }
}

*/
