class UserModel {
  static const tableName = "users";
  String? uid;
  String? name;
  String? email;
  String? password;
  String? customerId;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.customerId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map["uid"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      password: map["password"] ?? "",
      customerId: map["customerId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "customerId": customerId,
    };
  }
}
