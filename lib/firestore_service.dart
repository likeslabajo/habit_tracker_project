import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String colorHex;

  Habit({required this.id, required this.name, required this.colorHex});

  factory Habit.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] as String,
      colorHex: data['colorHex'] as String,
    );
  }
}

/// Wraps all Firestore reads/writes for a single user's habits + daily logs.
///
/// Data shape:
///   users/{uid}/habits/{habitId}            -> { name, colorHex, createdAt }
///   users/{uid}/dailyLogs/{yyyy-MM-dd}       -> { habitId1: true, habitId2: false, ... }
class FirestoreService {
  final String uid;
  FirestoreService(this.uid);

  CollectionReference get _habitsRef => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('habits');

  CollectionReference get _dailyLogsRef => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('dailyLogs');

  DocumentReference _dailyLogDoc(String date) => _dailyLogsRef.doc(date);

  /// Live list of the user's habits (name + color), ordered by creation time.
  Stream<List<Habit>> habitsStream() {
    return _habitsRef.orderBy('createdAt').snapshots().map(
          (snap) => snap.docs.map((d) => Habit.fromDoc(d)).toList(),
        );
  }

  /// Live completion map for a single day: { habitId: true/false }.
  /// Missing entries are treated as "not completed".
  Stream<Map<String, bool>> dailyLogStream(String date) {
    return _dailyLogDoc(date).snapshots().map((doc) {
      if (!doc.exists) return <String, bool>{};
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return data.map((key, value) => MapEntry(key, value == true));
    });
  }

  Future<void> addHabit(String name, String colorHex) async {
    await _habitsRef.add({
      'name': name,
      'colorHex': colorHex,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitsRef.doc(habitId).delete();
    // Note: past dailyLogs entries for this habitId are left in place on
    // purpose, so historical stats/streaks aren't silently rewritten.
  }

  Future<void> setHabitCompletion(
    String date,
    String habitId,
    bool completed,
  ) async {
    await _dailyLogDoc(date).set(
      {habitId: completed},
      SetOptions(merge: true),
    );
  }

  /// One-time fetch of daily logs between two 'yyyy-MM-dd' dates (inclusive),
  /// used by the Reports/history screen.
  Future<Map<String, Map<String, bool>>> logsInRange(
    String startDate,
    String endDate,
  ) async {
    final snap = await _dailyLogsRef
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: startDate)
        .where(FieldPath.documentId, isLessThanOrEqualTo: endDate)
        .get();

    final result = <String, Map<String, bool>>{};
    for (final doc in snap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      result[doc.id] = data.map((k, v) => MapEntry(k, v == true));
    }
    return result;
  }
}