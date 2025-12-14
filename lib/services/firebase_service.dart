// lib/core/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/trip_model.dart';
import '../../models/expense_model.dart';
import '../../models/destination_model.dart';
import '../../models/review_model.dart';
import '../../models/alert_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // ==========================================
  // TRIP OPERATIONS
  // ==========================================

  static Future<void> syncTrip(TripModel trip) async {
    try {
      await _firestore.collection('trips').doc(trip.id).set(trip.toJson());
    } catch (e) {
      throw Exception('Failed to sync trip: $e');
    }
  }

  static Future<List<TripModel>> fetchTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('userId', isEqualTo: userId)
          .orderBy('startDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips: $e');
    }
  }

  static Future<TripModel?> fetchTripById(String id) async {
    try {
      final doc = await _firestore.collection('trips').doc(id).get();
      if (!doc.exists) return null;
      return TripModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch trip: $e');
    }
  }

  static Future<void> updateTrip(TripModel trip) async {
    try {
      await _firestore.collection('trips').doc(trip.id).update(trip.toJson());
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  static Future<void> deleteTrip(String id) async {
    try {
      await _firestore.collection('trips').doc(id).delete();
      // Also delete associated expenses
      final expensesSnapshot = await _firestore
          .collection('expenses')
          .where('tripId', isEqualTo: id)
          .get();

      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }

  // ==========================================
  // EXPENSE OPERATIONS
  // ==========================================

  static Future<void> syncExpense(ExpenseModel expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toJson());
    } catch (e) {
      throw Exception('Failed to sync expense: $e');
    }
  }

  static Future<List<ExpenseModel>> fetchExpenses(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('expenses')
          .where('tripId', isEqualTo: tripId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ExpenseModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .update(expense.toJson());
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  static Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  // ==========================================
  // DESTINATION OPERATIONS
  // ==========================================

  static Future<List<DestinationModel>> getDestinations() async {
    try {
      final snapshot = await _firestore
          .collection('destinations')
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => DestinationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch destinations: $e');
    }
  }

  static Future<DestinationModel?> getDestinationById(String id) async {
    try {
      final doc = await _firestore.collection('destinations').doc(id).get();
      if (!doc.exists) return null;
      return DestinationModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch destination: $e');
    }
  }

  static Future<List<DestinationModel>> getDestinationsByProvince(
    String province,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('destinations')
          .where('province', isEqualTo: province)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => DestinationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch destinations: $e');
    }
  }

  static Future<void> addDestination(DestinationModel destination) async {
    try {
      await _firestore
          .collection('destinations')
          .doc(destination.id)
          .set(destination.toJson());
    } catch (e) {
      throw Exception('Failed to add destination: $e');
    }
  }

  // ==========================================
  // REVIEW OPERATIONS
  // ==========================================

  static Future<void> syncReview(ReviewModel review) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .set(review.toJson());
    } catch (e) {
      throw Exception('Failed to sync review: $e');
    }
  }

  static Future<List<ReviewModel>> fetchReviews(String destinationId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('destinationId', isEqualTo: destinationId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  static Future<void> updateReview(ReviewModel review) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .update(review.toJson());
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  static Future<void> deleteReview(String id) async {
    try {
      await _firestore.collection('reviews').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  // ==========================================
  // ALERT OPERATIONS (Real-time Database)
  // ==========================================

  static Future<List<AlertModel>> fetchAlerts() async {
    try {
      final snapshot = await _database.child('alerts').get();
      if (snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries
          .map((e) => AlertModel.fromJson(Map<String, dynamic>.from(e.value)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  static Stream<List<AlertModel>> streamAlerts() {
    return _database.child('alerts').onValue.map((event) {
      if (event.snapshot.value == null) return <AlertModel>[];

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries
          .map((e) => AlertModel.fromJson(Map<String, dynamic>.from(e.value)))
          .toList();
    });
  }

  static Future<List<AlertModel>> fetchAlertsByLocation(String location) async {
    try {
      final snapshot = await _database
          .child('alerts')
          .orderByChild('location')
          .equalTo(location)
          .get();

      if (snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries
          .map((e) => AlertModel.fromJson(Map<String, dynamic>.from(e.value)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  static Future<void> addAlert(AlertModel alert) async {
    try {
      await _database.child('alerts/${alert.id}').set(alert.toJson());
    } catch (e) {
      throw Exception('Failed to add alert: $e');
    }
  }

  static Future<void> updateAlert(AlertModel alert) async {
    try {
      await _database.child('alerts/${alert.id}').update(alert.toJson());
    } catch (e) {
      throw Exception('Failed to update alert: $e');
    }
  }

  static Future<void> deleteAlert(String id) async {
    try {
      await _database.child('alerts/$id').remove();
    } catch (e) {
      throw Exception('Failed to delete alert: $e');
    }
  }

  // ==========================================
  // BATCH OPERATIONS
  // ==========================================

  static Future<void> batchSyncTrips(List<TripModel> trips) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var trip in trips) {
        DocumentReference ref = _firestore.collection('trips').doc(trip.id);
        batch.set(ref, trip.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch sync trips: $e');
    }
  }

  static Future<void> batchSyncExpenses(List<ExpenseModel> expenses) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var expense in expenses) {
        DocumentReference ref = _firestore
            .collection('expenses')
            .doc(expense.id);
        batch.set(ref, expense.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch sync expenses: $e');
    }
  }
}
