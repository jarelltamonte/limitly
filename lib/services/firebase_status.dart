import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStatus {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Test if Firebase is still accessible for read operations
  static Future<bool> testReadAccess() async {
    try {
      final snapshot = await _firestore.collection('test').limit(1).get();
      print('✅ Firebase READ access: OK');
      return true;
    } catch (e) {
      print('❌ Firebase READ access: FAILED - $e');
      return false;
    }
  }

  /// Test if Firebase is still accessible for write operations
  static Future<bool> testWriteAccess() async {
    try {
      final testDoc = _firestore.collection('test').doc('quota_test');
      await testDoc.set({
        'timestamp': DateTime.now().toIso8601String(),
        'test': 'quota_check',
      });
      
      // Clean up test document
      await testDoc.delete();
      
      print('✅ Firebase WRITE access: OK');
      return true;
    } catch (e) {
      print('❌ Firebase WRITE access: FAILED - $e');
      return false;
    }
  }

  /// Test if Firebase is still accessible for delete operations
  static Future<bool> testDeleteAccess() async {
    try {
      final testDoc = _firestore.collection('test').doc('delete_test');
      await testDoc.set({'test': 'delete_check'});
      await testDoc.delete();
      
      print('✅ Firebase DELETE access: OK');
      return true;
    } catch (e) {
      print('❌ Firebase DELETE access: FAILED - $e');
      return false;
    }
  }

  /// Comprehensive Firebase status check
  static Future<Map<String, bool>> checkAllAccess() async {
    print('🔍 Checking Firebase access...');
    
    final results = {
      'read': await testReadAccess(),
      'write': await testWriteAccess(),
      'delete': await testDeleteAccess(),
    };
    
    print('📊 Firebase Status Summary:');
    results.forEach((operation, status) {
      print('  ${operation.toUpperCase()}: ${status ? "✅ OK" : "❌ FAILED"}');
    });
    
    return results;
  }

  /// Get current quota usage (approximate)
  static Future<void> checkQuotaStatus() async {
    try {
      // Try to read a small amount of data to check quota
      final snapshot = await _firestore.collection('expenses').limit(1).get();
      print('✅ Quota check: Can still read data');
    } catch (e) {
      if (e.toString().contains('quota') || e.toString().contains('limit')) {
        print('❌ QUOTA EXCEEDED: Firebase read operations are blocked');
      } else {
        print('⚠️ Firebase error (may be quota related): $e');
      }
    }
  }
} 