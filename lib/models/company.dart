class Company {
  int id;
  String? title;
  String? address;
  dynamic latitude;
  dynamic longitude;
  String? createdAt;
  String? updatedAt;

  Company({
    required this.id,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        title: json["title"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}



/* 

"company": {
  "id": 17,
  "title": "TATU Fergana",
  "address": "fargona 23",
  "latitude": null,
  "longitude": null,
  "created_at": "2023-06-16T11:47:01.000000Z",
  "updated_at": "2023-06-16T13:16:22.000000Z"
}

*/