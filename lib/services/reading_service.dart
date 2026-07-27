import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }

    return _firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('lecturas');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamReadings() {
    return _collection().orderBy('fechaRegistro', descending: true).snapshots();
  }

  Future<void> saveReading({
    String? id,
    required String testamento,
    required String libro,
    required int capitulo,
    required int versiculoInicio,
    required int versiculoFin,
    DateTime? fechaLectura,
  }) async {
    final now = Timestamp.now();
    final selectedDate = fechaLectura ?? now.toDate();
    final data = {
      'testamento': testamento,
      'libro': libro,
      'capitulo': capitulo,
      'versiculoInicio': versiculoInicio,
      'versiculoFin': versiculoFin,
      'cita': '$libro $capitulo:$versiculoInicio-$versiculoFin',
      'fechaActualizacion': now,
    };

    if (id == null) {
      await _collection().add({
        ...data,
        'fechaLectura': Timestamp.fromDate(selectedDate),
        'fechaRegistro': now,
      });
      return;
    }

    await _collection().doc(id).update({
      ...data,
      'fechaLectura': Timestamp.fromDate(selectedDate),
    });
  }
}
