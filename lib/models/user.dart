import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String key;
  String _fullname = 'Soi', _stuID = '20161003441', _userId;
  String _identity = 'teacher';

  User();

  String get userId => _userId;
  setUserId(String value) {
    _userId = value;
  }

  String get fullname => _fullname;
  setFullname(String value) {
    _fullname = value;
  }

  String get identity => _identity;
  setIdentity(String value) {
    _identity = value;
  }

  String get stuID => _stuID;
  setStuID(String value) {
    _stuID = value;
  }

  User.fromSnapshot(QuerySnapshot snapshot)
      : key = snapshot.documents[0].documentID,
        _userId = snapshot.documents[0].data['userId'],
        _fullname = snapshot.documents[0].data["fullname"],
        _stuID = snapshot.documents[0].data["stuId"],
        _identity = snapshot.documents[0].data["identity"];

  toJson() {
    if (identity == "student") {
      return {
        "userId": _userId,
        "fullname": _fullname,
        "stuId": _stuID,
        "identity": _identity,
      };
    } else {
      return {
        "userId": _userId,
        "fullname": _fullname,
        "identity": _identity,
      };
    }
  }
}
