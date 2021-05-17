import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static FirestoreService _service = FirestoreService._();
  FirestoreService._();
  factory FirestoreService() => _service;

  final _firestore = FirebaseFirestore.instance;

  Future<List<T>> queryData<T>({
    String path,
    T builder(Map<String, dynamic> data, String id, DocumentSnapshot lastDoc),
    Query queryBuilder(Query query),
  }) async {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final _doc = await query.get();
    return _doc.docs
        .map<T>((e) => builder(e.data(), e.id, _doc.docs.last))
        .toList();
  }
}


