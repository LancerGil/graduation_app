import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationapp/utils/firebase_store.dart';

import '../models/index.dart';

abstract class BaseCommentRepository {
  Future<List<CommentAngle>> checkComments(User user, bool fromMe);
}

class CommentRepository extends BaseCommentRepository {
  BaseFireBaseStore fireBaseStore = FireBaseStore();
  @override
  Future<List<CommentAngle>> checkComments(user, fromMe) async {
    QuerySnapshot snapshot = await fireBaseStore.queryDocuments(
      'peer_comment',
      MapEntry(
        fromMe ? 'commentUserID' : 'submitUserID',
        user.userId,
      ),
    );
    return snapshot.documents
        .map<CommentAngle>((e) => CommentAngle.fromSnapshot(e))
        .toList();
  }
}
