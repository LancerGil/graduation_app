import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationapp/models/reply.dart';
import 'package:graduationapp/models/user.dart';
import 'package:graduationapp/utils/firebase_store.dart';

abstract class BaseReplyRepository {
  /// Throws [NetworkException].
  Future<List<Reply>> checkReply(User user, bool fromMe);
}

class ReplyRepository extends BaseReplyRepository {
  BaseFireBaseStore fireBaseStore = FireBaseStore();
  @override
  Future<List<Reply>> checkReply(User user, bool fromMe) async {
    List<Reply> replies = new List();
    QuerySnapshot snapshot = await fireBaseStore.queryDocuments(
      'reply',
      MapEntry(
        fromMe ? 'myUserID' : 'oppositeUserID',
        user.userId,
      ),
    );
    if (snapshot.documents != null && snapshot.documents.isNotEmpty) {
      replies =
          snapshot.documents.map<Reply>((e) => Reply.fromSnapshot(e)).toList();
    }
    return replies;
  }
}
