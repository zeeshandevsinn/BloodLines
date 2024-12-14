import 'package:bloodlines/userModel.dart';

class SingletonUser {
  static final SingletonUser singletonClass = SingletonUser._internal();

  UserModel? user;
  factory SingletonUser() {
    return singletonClass;
  }
  void setUser(UserModel users) {
    user = users;
  }

  UserModel? get getUser {
    return user;
  }

  SingletonUser._internal();
}
