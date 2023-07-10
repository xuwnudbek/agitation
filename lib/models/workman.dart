class Workman {
  int id;
  String? image;
  String? name;
  String? username;
  String? surname;
  String? phone;
  int? city_id;
  String? address;
  String? password;
  int? group_id;
  var status;

  String? created_at;
  String? updated_at;

  int todayFinishedTasks = 0;
  set setTodayFinishedTasks(int value) => todayFinishedTasks = value;

  int allFinishedTasks = 0;
  set setAllFinishedTasks(int value) => allFinishedTasks = value;

  Workman({
    required this.id,
    this.image,
    required this.name,
    required this.username,
    required this.surname,
    required this.phone,
    required this.city_id,
    required this.address,
    required this.password,
    required this.group_id,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory Workman.fromJson(Map<String, dynamic> data) {
    return Workman(
      id: data['id'],
      image: data['image'],
      name: data['name'],
      username: data['username'],
      surname: data['surname'],
      phone: data['phone'],
      city_id: data['city_id'],
      address: data['address'],
      password: data['password'],
      group_id: data['group_id'],
      status: data['status'],
      created_at: data['created_at'],
      updated_at: data['updated_at'],
    );
  }
}

/*
  "id": 29,
  "image": null,
  "name": "My name",
  "username": "My name",
  "surname": "surname",
  "phone": "+998907823396",
  "city_id": "1",
  "address": "my addres",
  "password": "$2y$10$L7LH1ikwU2UiIK/OAkHwk.NMD0k1niiU7aTULn/UDi6ojbvWyl5w.",
  "group_id": "11",
  "status": "1",
  "created_at": "2023-06-19T09:36:29.000000Z",
  "updated_at": "2023-06-19T11:44:15.000000Z"
*/