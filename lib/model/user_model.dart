class UserModel {
  String? email;
  String? uid;

// receiving data
  UserModel({this.uid, this.email,});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  static UserModel? fromJson(data) {}
}