import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String uid) {
    return _firestore.collection('usuarios').doc(uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return _firestore.collection('usuarios').doc(uid).get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('usuarios')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final ref = _storage
        .ref()
        .child('usuarios')
        .child(uid)
        .child('profile.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
  }
}
