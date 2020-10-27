import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFireBaseStore {
  Future<void> addDocument(collection, Map dataJson);
  Future<QuerySnapshot> queryDocuments(
      collection, MapEntry<String, dynamic> mapEntry);
  Future<QuerySnapshot> getDocument(String docID);
  Future<QuerySnapshot> doubleQueryDocuments(
      collection, Map<String, dynamic> map);
  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> dataJson);
  Future<void> deleteDocument(String collection, String documentId);
}

class FireBaseStore extends BaseFireBaseStore {
  final Firestore fireStore = Firestore.instance;

  @override
  addDocument(collection, Map dataJson) async {
    print('Add document to collection--$collection');
    await fireStore.collection(collection).document().setData(dataJson);
  }

  @override
  Future<QuerySnapshot> queryDocuments(
      collection, MapEntry<String, dynamic> mapEntry,
      {bool isInList = false}) async {
    if (isInList) {
      return await Firestore.instance
          .collection(collection)
          .where(mapEntry.key, arrayContains: mapEntry.value)
          .getDocuments();
    } else
      return await Firestore.instance
          .collection(collection)
          .where(mapEntry.key, isEqualTo: mapEntry.value)
          .getDocuments();
  }

  @override
  Future<QuerySnapshot> getDocument(String docID) {
    // TODO: implement getDocument
    throw UnimplementedError();
  }

  @override
  Future<QuerySnapshot> doubleQueryDocuments(
      collection, Map<String, dynamic> map) async {
    return await Firestore.instance
        .collection(collection)
        .where(map.keys.first, isEqualTo: map.values.first)
        .where(map.keys.last, isEqualTo: map.values.last)
        .getDocuments();
  }

  @override
  Future<void> updateDocument(String collection, String documentId,
      Map<String, dynamic> dataJson) async {
    await fireStore
        .collection(collection)
        .document(documentId)
        .updateData(dataJson);
  }

  @override
  Future<void> deleteDocument(String collection, String documentId) async {
    await fireStore.collection(collection).document(documentId).delete();
  }
}
