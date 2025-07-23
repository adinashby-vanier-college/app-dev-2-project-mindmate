import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user profile (call this after sign up)
  Future<void> createUserProfile(String userId, String username, String email) async {
    try {
      await _db.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  // Save mood entry (for your quote screen)
  Future<void> saveMoodEntry(String userId, int moodLevel, String? note) async {
    try {
      await _db.collection('users').doc(userId).collection('moods').add({
        'moodLevel': moodLevel,
        'note': note ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving mood: $e');
      rethrow;
    }
  }

  // Get mood history (for journal screen)
  Stream<QuerySnapshot> getMoodHistory(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Save journal entry
  Future<void> saveJournalEntry(String userId, String content) async {
    try {
      await _db.collection('users').doc(userId).collection('journal').add({
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving journal: $e');
      rethrow;
    }
  }

  // Get journal entries
  Stream<QuerySnapshot> getJournalEntries(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('journal')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}