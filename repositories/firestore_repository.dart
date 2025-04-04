import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int pageSize = 10;

  Future<List<DocumentSnapshot>> fetchItems({DocumentSnapshot? lastDoc}) async {
    try {
      Query query = _firestore.collection('items').orderBy('timestamp').limit(pageSize);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Ошибка загрузки данных');
    }
  }
}
