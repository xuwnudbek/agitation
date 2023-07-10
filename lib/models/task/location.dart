import 'package:agitation/models/workman.dart';

class Location {
  int? id;
  String? latitude;
  String? longitude;
  String? address;
  int? workerId;
  int? taskId;
  String? createdAt;
  String? updatedAt;
  Workman? workman;

  Location({
    this.id,
    this.latitude,
    this.longitude,
    this.address,
    this.workerId,
    this.taskId,
    this.createdAt,
    this.updatedAt,
    this.workman,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    workerId = json['worker_id'];
    taskId = json['task_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    workman = json['worker'] != null ? new Workman.fromJson(json['worker']) : null;
  }
}

/*

{
  "id": 1,
  "latitude": "40.37560113017747",
  "longitude": "71.785838752985",
  "address": "51 Аlisher Navoi ko'chasi, 34 Аlisher Navoi ko'chasi, 12 Аlisher Navoi ko'chasi, Frunzenskiy Massiv, Farg'ona,",
  "worker_id": "1",
  "task_id": "1",
  "created_at": "2023-06-22T13:29:55.000000Z",
  "updated_at": "2023-06-22T13:29:55.000000Z",
  "worker": {
    "id": 1,
    "name": "Xushnudbek",
    "image": null,
    "surname": "Abdusamatov",
    "phone": "+998902902614",
    "username": "xuwnudbek",
    "city_id": "1",
    "address": "Alisher Navoiy 54-uy",
    "password": "$2y$10$PZmAh/AKV3FYgIU1IaXsbeQZ6gyyixm3ABSCCi9vnzAbaa1fuZ352",
    "group_id": "1",
    "status": 0,
    "created_at": "2023-06-22T11:00:07.000000Z",
    "updated_at": "2023-06-22T12:03:24.000000Z"
  }
},

*/