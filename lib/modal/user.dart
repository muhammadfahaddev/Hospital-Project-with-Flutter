class UserModel {
  String uid;
  String imageUrl;
  String name;
  String email;
  String phoneNo;
  String dob;
  String password;

  UserModel({
    required this.uid,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.dob,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      imageUrl: data['image'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
      dob: data['dob'] ?? '',
      password: data['password'] ?? '',
    );
  }
}
