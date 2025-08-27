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

  // Save mood entry (for your quote screen) - KEEP ORIGINAL
  Future<void> saveMoodEntry(String userId, double moodLevel, String? note) async {
    try {
      await _db.collection('users').doc(userId).collection('moods').add({
        'moodLevel': moodLevel,
        'note': note ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'date': DateTime.now().toIso8601String().split('T')[0],
      });
      print('✅ Mood entry saved: $moodLevel');
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

  // Save journal entry - ORIGINAL SIGNATURE
  Future<void> saveJournalEntry(String userId, String content, double moodLevel) async {
    try {
      await _db.collection('users').doc(userId).collection('journal').add({
        'content': content,
        'moodLevel': moodLevel,
        'timestamp': FieldValue.serverTimestamp(),
        'date': DateTime.now().toIso8601String().split('T')[0],
      });
      print('✅ Journal entry saved');
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

  // Update mood entry
  Future<void> updateMoodEntry(String userId, String entryId, double moodLevel, String? note) async {
    try {
      await _db.collection('users').doc(userId).collection('moods').doc(entryId).update({
        'moodLevel': moodLevel,
        'note': note ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating mood: $e');
      rethrow;
    }
  }

  // Delete mood entry
  Future<void> deleteMoodEntry(String userId, String entryId) async {
    try {
      await _db.collection('users').doc(userId).collection('moods').doc(entryId).delete();
    } catch (e) {
      print('Error deleting mood: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}