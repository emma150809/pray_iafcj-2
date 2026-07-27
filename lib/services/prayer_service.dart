import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrayerService {
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
        .collection('oraciones');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPrayers() {
    return _collection().orderBy('fechaRegistro', descending: true).snapshots();
  }

  Future<void> savePrayer({
    String? id,
    DateTime? fechaOracion,
    required String tiempoOracion,
  }) async {
    final now = Timestamp.now();
    final selectedDate = fechaOracion ?? now.toDate();
    final formattedTime = tiempoOracion.trim().isEmpty
        ? '0h 15m'
        : tiempoOracion.trim();

    final data = {'tiempoOracion': formattedTime, 'fechaActualizacion': now};

    if (id == null) {
      await _collection().add({
        ...data,
        'fechaOracion': Timestamp.fromDate(selectedDate),
        'fechaRegistro': now,
      });
      return;
    }

    await _collection().doc(id).update({
      ...data,
      'fechaOracion': Timestamp.fromDate(selectedDate),
    });
  }
}
