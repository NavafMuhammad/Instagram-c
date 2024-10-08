

import 'package:flutter/foundation.dart';
import 'package:instagram_flutter/domain/auth_methods.dart';
import 'package:instagram_flutter/domain/models/user_model.dart';

class UserProvider with ChangeNotifier{
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _userModel = user;
    notifyListeners();
  }
}