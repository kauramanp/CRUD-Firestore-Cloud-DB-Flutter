class Users {
  Users({
    required this.name,
    required this.address,
  });

  String name;
  String address;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "address": address == null ? null : address,
      };
}
