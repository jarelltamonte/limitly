import 'dart:convert';
import 'package:firebase_admin/firebase_admin.dart' as admin;

void main() async {
  final app = admin.FirebaseAdmin.instance.initializeApp(
    admin.AppOptions(
      credential: admin.ServiceAccountCredential.fromJson({
        "type": "service_account",
        "project_id": "limitly-f5acc",
        "private_key_id": "b565e0857e88eb29550bf2730eee0a06ed571de0",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDjv9uumGHdAdN8\nRIy813QCREj4TaYLn+l242YLtx6skAzQj8n28OuhWOJ5VBMmuqk8vFVj6cGYonoX\nDp3bmkgrBI22Uy5i+PzmlQH+fLlEPe+9kjEpPpcjmpVfTLYkRyX/jkezWIqDGbOs\nszw/gNfvxXQVpEdffTRV4bZ3sGG0aEMJVhhy0tqjrYMJNlq1BjjAk7Mi+gHoPmeb\nBqYDs3FhvCsakLHGxvC4OwrvGNzEzesHLx0u+64eXr0N0zw95qkzMF06ikJk9h9+\nkBhFlWeACVSYAF6X7ZCU1WphXLvTmRTwuTzdtBQxzCuFVz9paKIkuxGboD2z9KQ4\nZrbDYFB5AgMBAAECggEACrXZFOrhn00Yrv1iSPcw43JmpBayulU423hyMhbYgHD9\nyUkZzF0kF6Bgdig4Blg84ThSI7K4gf8SEseDMPKedjdumqZqxgjDi+xx/Y/L/qOT\nBK09Vp006l24rJSk9CvMY6pDQPHnAadRxctgB/R9My9r+CCToq/2qBtHQ3WuApfV\n3+/dVEJ8OvaxU/2ehnEWHv3zIAufC7MD5el2r3KfExQsNps0DrNcTfspI5fa4rq/\nZyKqLJQCYmCqazgUOk9w1KtCUlrKj0fC4fE1taQjrcCuEi/T8Q5BmCmX+HdASoIr\n2OxBAaNw4Au6nE91kUZSdxaGQeXaKdbMyXOF9xoYiQKBgQD/iYDA77vNT2phMMm9\neJGOL6TKK7PTjXRsFcibFTZbAJBrvb7i1HkHf5iA6gBm0OZhIYkUCmWPsfeiDZ8s\nJ5WDEh4oNnvu4WMsENkWdqHOkcDIbdaPDEFir69OuQFnyhHDGR3HhcA1Gy+5S2C1\nbob6onhduleC/w1uqEv9A0InFwKBgQDkKXg0yAw2kvss60iwK2CErtR8fHHymxMc\ngKTTNCcoLhEPXtyNKyrw6u6yqHsZicfMMOXiqiLp5UFUKF1O2bVk6miCoPPWFT1h\n7Uq4zvbPbdaZjISrwVCXBJ01kX77gxgm5A7r92V1eZJskyq2cNcLO72wsESSMpSX\nuPISvfP+7wKBgQCdT2/U1oCdpssNY/R90LCCgLAIyZidnpJSS6LAXfGlWhaOTTQq\nbQ4OoOOsP9oTCfXGccCcFgPevbAa3RWwVOYadno1Ym8CEJ+CS0rWALKYQ32FTAl\nxdymvRLF+rxzwYDnwxmDD8LArqjVgCLb7lvoBYbl5GYlPZBuU+rbqlraJwKBgFiY\nYbzdESD/4diHZCpELa5X1Nqh1/1Eih8/NMFuNuY7PRSi2TFX2czC7P0ivuojvhlj\nw2BIgFYiV0O+iLzdfLo662oN5aDzjmpAIguxEdVp6TKmhb3LyudZO1JZtN0lAnPX\nipPF9PewxVKzspo1JsuN3xKE35uFWH2xqw3sBJqxAoGBAIw8b1o2udS6kd8TJnXM\nbI8S5G2tChdR4AB/gHuNshcOSNqSX0rm8YilbHwFjyts3jRPBqCEEKrSqWM5qS7u\nkYIRv8VNiQsQ6wlFNh1uNDNsWFr8do7jc1jPHAD2k5L1Q1NPcCTeETeDHjI32Ab4\nyPWOEv69AttJ0zAYLcFQdb1+\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-fbsvc@limitly-f5acc.iam.gserviceaccount.com",
        "client_id": "104238067660752774217",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40limitly-f5acc.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      projectId: 'limitly-f5acc',
    ),
  );

  final firestore = admin.FirebaseAdmin.instance.firestore();

  // Expense categories
  final expenseCategories = [
    "Food",
    "Transport",
    "Health",
    "Shopping",
    "Rent",
    "Gift",
    "Savings",
    "Entertainment",
  ];
  for (final category in expenseCategories) {
    await firestore.collection('expense_categories').add({'name': category});
  }

  // Expenses
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
    await firestore.collection('expenses').doc(expense['id']).set(expense);
  }

  // Savings categories
  final savingsCategories = [
    {"name": "Travel", "targetAmount": 20000.0},
    {"name": "House", "targetAmount": 500250.0},
    {"name": "Car", "targetAmount": 54190.0},
    {"name": "Wedding", "targetAmount": 14190.0},
  ];
  for (final category in savingsCategories) {
    await firestore.collection('savings_categories').add(category);
  }

  // Savings
  final savings = [
    // Travel
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
    // House
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
    // Car
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
      "title": "House Deposit",
      "amount": 133.91,
      "category": "Car",
      "date": DateTime(2024, 5, 9, 10, 0).toIso8601String(),
      "targetAmount": 54190.0,
    },
    // Wedding
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
    await firestore.collection('savings').doc(saving['id']).set(saving);
  }

  print('Firestore database populated successfully!');
}