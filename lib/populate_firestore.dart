import 'dart:io';
import 'package:firebase_admin/firebase_admin.dart' as admin;
import 'package:firebase_admin/src/credential.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  try {
    final serviceAccountPath = path.join(
      Directory.current.path,
      'serviceAccountKey.json',
    );

    final app = admin.FirebaseAdmin.instance.initializeApp(
      admin.AppOptions(
        credential: ServiceAccountCredential.fromPath(serviceAccountPath),
        projectId: 'limitly-f5acc',
      ),
    );

    final firestore = admin.FirebaseAdmin.instance.firestore();

    await populateExpenseCategories(firestore);
    await populateExpenses(firestore);
    await populateSavingsCategories(firestore);
    await populateSavings(firestore);

    print('✅ Firestore database populated successfully!');
  } catch (e) {
    print('❌ Error populating Firestore: $e');
  }
}

Future<void> populateExpenseCategories(admin.Firestore firestore) async {
  final categories = [
    "Food",
    "Transport",
    "Health",
    "Shopping",
    "Rent",
    "Gift",
    "Savings",
    "Entertainment",
  ];

  for (final category in categories) {
    await firestore.collection('expense_categories').doc(category).set({
      'name': category,
    }, SetOptions(merge: true));
  }

  print('✅ Expense categories added.');
}

Future<void> populateExpenses(admin.Firestore firestore) async {
  final expenses = [
    {
      "id": "1",
      "title": "Dinner",
      "amount": 26.00,
      "category": "Food",
      "date": DateTime(2024, 4, 30, 18, 27).toIso8601String(),
    },
    {
      "id": "2",
      "title": "Delivery Pizza",
      "amount": 18.35,
      "category": "Food",
      "date": DateTime(2024, 4, 24, 15, 0).toIso8601String(),
    },
    {
      "id": "3",
      "title": "Lunch",
      "amount": 15.40,
      "category": "Food",
      "date": DateTime(2024, 4, 15, 12, 30).toIso8601String(),
    },
    {
      "id": "4",
      "title": "Brunch",
      "amount": 12.13,
      "category": "Food",
      "date": DateTime(2024, 4, 8, 8, 30).toIso8601String(),
    },
    {
      "id": "5",
      "title": "Dinner",
      "amount": 27.20,
      "category": "Food",
      "date": DateTime(2024, 3, 31, 20, 50).toIso8601String(),
    },
  ];

  for (final expense in expenses) {
    await firestore
        .collection('expenses')
        .doc(expense['id']!)
        .set(expense, SetOptions(merge: true));
  }

  print('✅ Expenses added.');
}

Future<void> populateSavingsCategories(admin.Firestore firestore) async {
  final savingsCategories = [
    {"name": "Travel", "targetAmount": 20000.0},
    {"name": "House", "targetAmount": 500250.0},
    {"name": "Car", "targetAmount": 54190.0},
    {"name": "Wedding", "targetAmount": 14190.0},
  ];

  for (final category in savingsCategories) {
    await firestore
        .collection('savings_categories')
        .doc(category['name'])
        .set(category, SetOptions(merge: true));
  }

  print('✅ Savings categories added.');
}

Future<void> populateSavings(admin.Firestore firestore) async {
  final savings = [
    {
      "id": "1",
      "title": "Travel Deposit",
      "amount": 231.17,
      "category": "Travel",
      "date": DateTime(2024, 4, 30, 16, 0).toIso8601String(),
      "targetAmount": 20000.0,
    },
    {
      "id": "2",
      "title": "Travel Deposit",
      "amount": 231.17,
      "category": "Travel",
      "date": DateTime(2024, 4, 14, 17, 0).toIso8601String(),
      "targetAmount": 20000.0,
    },
    {
      "id": "3",
      "title": "Travel Deposit",
      "amount": 191.17,
      "category": "Travel",
      "date": DateTime(2024, 4, 2, 13, 20).toIso8601String(),
      "targetAmount": 20000.0,
    },
    {
      "id": "4",
      "title": "House Deposit",
      "amount": 231.17,
      "category": "House",
      "date": DateTime(2024, 4, 1, 19, 55).toIso8601String(),
      "targetAmount": 500250.0,
    },
    {
      "id": "5",
      "title": "House Deposit",
      "amount": 231.17,
      "category": "House",
      "date": DateTime(2024, 1, 18, 20, 20).toIso8601String(),
      "targetAmount": 500250.0,
    },
    {
      "id": "6",
      "title": "House Deposit",
      "amount": 163.14,
      "category": "House",
      "date": DateTime(2024, 1, 10, 19, 0).toIso8601String(),
      "targetAmount": 500250.0,
    },
    {
      "id": "7",
      "title": "Car Deposit",
      "amount": 231.17,
      "category": "Car",
      "date": DateTime(2024, 7, 1, 12, 0).toIso8601String(),
      "targetAmount": 54190.0,
    },
    {
      "id": "8",
      "title": "Car Deposit",
      "amount": 231.17,
      "category": "Car",
      "date": DateTime(2024, 5, 31, 15, 30).toIso8601String(),
      "targetAmount": 54190.0,
    },
    {
      "id": "9",
      "title": "Car Deposit",
      "amount": 133.91,
      "category": "Car",
      "date": DateTime(2024, 5, 9, 10, 0).toIso8601String(),
      "targetAmount": 54190.0,
    },
    {
      "id": "10",
      "title": "Wedding Deposit",
      "amount": 183.32,
      "category": "Wedding",
      "date": DateTime(2024, 11, 15, 18, 45).toIso8601String(),
      "targetAmount": 14190.0,
    },
    {
      "id": "11",
      "title": "Wedding Deposit",
      "amount": 183.32,
      "category": "Wedding",
      "date": DateTime(2024, 9, 20, 20, 0).toIso8601String(),
      "targetAmount": 14190.0,
    },
    {
      "id": "12",
      "title": "Wedding Deposit",
      "amount": 183.32,
      "category": "Wedding",
      "date": DateTime(2024, 9, 15, 19, 0).toIso8601String(),
      "targetAmount": 14190.0,
    },
  ];

  for (final saving in savings) {
    await firestore
        .collection('savings')
        .doc(saving['id']!)
        .set(saving, SetOptions(merge: true));
  }

  print('✅ Savings added.');
}
