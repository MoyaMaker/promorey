import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promorey/models/promotion.dart';

class FirestoreService {
  final CollectionReference _promotions =
      FirebaseFirestore.instance.collection('promotions');

  Future<List<Promotion>> getActivePromotions() async {
    final snapshot = await _promotions
        .where('isActive', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Promotion.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Promotion>> getUserPromotions(String userId) async {
    final snapshot = await _promotions
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Promotion.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Promotion?> getPromotionById(String id) async {
    final doc = await _promotions.doc(id).get();
    if (!doc.exists) return null;
    return Promotion.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> createPromotion(Promotion promotion) async {
    await _promotions.add(promotion.toMap());
  }

  Future<void> updatePromotion(Promotion promotion) async {
    await _promotions.doc(promotion.id).update(promotion.toMap());
  }

  Future<void> deletePromotion(String id) async {
    await _promotions.doc(id).delete();
  }
}
