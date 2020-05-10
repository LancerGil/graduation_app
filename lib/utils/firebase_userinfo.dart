import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationapp/models/user.dart';

abstract class BaseUserInfo {
  Future<void> updateUserInfor(String documentId, User userModel);

  Future<void> createUserInfor(User userModel);

  bool isInforSetted();

  Future<QuerySnapshot> getUserExtraInfor();
}

class FireBaseUserInfor implements BaseUserInfo {
  final String userId;

  FireBaseUserInfor(this.userId);

  final Firestore fireStore = Firestore.instance;

  @override
  Future<void> createUserInfor(User userModel) async {
    await fireStore.collection('user').document().setData(userModel.toJson());
  }

  @override
  bool isInforSetted() {
    return fireStore
            .collection('user')
            .where("userId", isEqualTo: userId)
            .snapshots()
            .length !=
        0;
  }

  @override
  Future<QuerySnapshot> getUserExtraInfor() async {
    return await fireStore
        .collection('user')
        .where("userId", isEqualTo: userId)
        .getDocuments();
  }

  @override
  Future<void> updateUserInfor(String documentId, User userModel) async {
    await fireStore
        .collection('user')
        .document(documentId)
        .updateData(userModel.toJson());
  }

  // @override
  // Future<void> deleteUser() {
  //   fireStore.reference().child("user").child(userId).remove();
  // }
}
