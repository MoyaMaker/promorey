import 'package:flutter/foundation.dart';
import 'package:promorey/models/promotion.dart';
import 'package:promorey/services/firestore_service.dart';
import 'package:promorey/utils/firestore_errors.dart';
// StorageService removed — Firebase Storage requires paid plan

class PromotionProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  // _storageService removed — Firebase Storage requires paid plan

  List<Promotion> _activePromotions = [];
  List<Promotion> _myPromotions = [];
  bool _isLoading = false;
  String? _error;

  List<Promotion> get activePromotions => _activePromotions;
  List<Promotion> get myPromotions => _myPromotions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadActivePromotions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activePromotions = await _firestoreService.getActivePromotions();
    } catch (e) {
      _error = getFirestoreErrorMessage(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMyPromotions(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _myPromotions = await _firestoreService.getUserPromotions(userId);
    } catch (e) {
      _error = getFirestoreErrorMessage(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createPromotion({
    required String title,
    required String description,
    required DateTime date,
    // imagePath removed — Firebase Storage requires paid plan
    required bool isActive,
    required String userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final promotion = Promotion(
        id: '',
        title: title,
        description: description,
        date: date,
        // imageUrl removed — Firebase Storage requires paid plan
        isActive: isActive,
        userId: userId,
        createdAt: DateTime.now(),
      );
      await _firestoreService.createPromotion(promotion);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = getFirestoreErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePromotion({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    // imagePath, existingImageUrl, removeImage removed — Firebase Storage requires paid plan
    required bool isActive,
    required String userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final promotion = Promotion(
        id: id,
        title: title,
        description: description,
        date: date,
        // imageUrl removed — Firebase Storage requires paid plan
        isActive: isActive,
        userId: userId,
        createdAt: DateTime.now(),
      );
      await _firestoreService.updatePromotion(promotion);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = getFirestoreErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // imageUrl param removed — Firebase Storage requires paid plan
  Future<bool> deletePromotion(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _firestoreService.deletePromotion(id);
      _myPromotions.removeWhere((p) => p.id == id);
      _activePromotions.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = getFirestoreErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
