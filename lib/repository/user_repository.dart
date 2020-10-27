import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_userinfo.dart';

abstract class BaseUserRepository {
  Future<User> getUserInfo(String userID);
}

class UserRepository extends BaseUserRepository {
  BaseUserInfo userInfoFirebase;
  @override
  Future<User> getUserInfo(String userID) async {
    userInfoFirebase = FireBaseUserInfor(userID);
    QuerySnapshot snapshot = await userInfoFirebase.getUserExtraInfor();
    if (snapshot.documents != null && snapshot.documents.isNotEmpty) {
      return User.fromSnapshot(snapshot);
    }
  }
}
