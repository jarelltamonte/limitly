const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function populate() {
  // Expense categories
  const expenseCategories = [
    "Food", "Transport", "Health", "Shopping", "Rent", "Gift", "Savings", "Entertainment"
  ];
  for (const category of expenseCategories) {
    await db.collection('expense_categories').add({ name: category });
  }

  // Expenses
  const expenses = [
    { id: "1", title: "Dinner", amount: 26.00, category: "Food", date: "2024-04-30T18:27:00" },
    { id: "2", title: "Delivery Pizza", amount: 18.35, category: "Food", date: "2024-04-24T15:00:00" },
    { id: "3", title: "Lunch", amount: 15.40, category: "Food", date: "2024-04-15T12:30:00" },
    { id: "4", title: "Brunch", amount: 12.13, category: "Food", date: "2024-04-08T08:30:00" },
    { id: "5", title: "Dinner", amount: 27.20, category: "Food", date: "2024-03-31T20:50:00" }
  ];
  for (const expense of expenses) {
    await db.collection('expenses').doc(expense.id).set(expense);
  }

  // Savings categories
  const savingsCategories = [
    { name: "Travel", targetAmount: 20000.0 },
    { name: "House", targetAmount: 500250.0 },
    { name: "Car", targetAmount: 54190.0 },
    { name: "Wedding", targetAmount: 14190.0 }
  ];
  for (const category of savingsCategories) {
    await db.collection('savings_categories').add(category);
  }

  // Savings
  const savings = [
    { id: "1", title: "Travel Deposit", amount: 231.17, category: "Travel", date: "2024-04-30T16:00:00", targetAmount: 20000.0 },
    { id: "2", title: "Travel Deposit", amount: 231.17, category: "Travel", date: "2024-04-14T17:00:00", targetAmount: 20000.0 },
    { id: "3", title: "Travel Deposit", amount: 191.17, category: "Travel", date: "2024-04-02T13:20:00", targetAmount: 20000.0 },
    { id: "4", title: "House Deposit", amount: 231.17, category: "House", date: "2024-04-01T19:55:00", targetAmount: 500250.0 },
    { id: "5", title: "House Deposit", amount: 231.17, category: "House", date: "2024-01-18T20:20:00", targetAmount: 500250.0 },
    { id: "6", title: "House Deposit", amount: 163.14, category: "House", date: "2024-01-10T19:00:00", targetAmount: 500250.0 },
    { id: "7", title: "Car Deposit", amount: 231.17, category: "Car", date: "2024-07-01T12:00:00", targetAmount: 54190.0 },
    { id: "8", title: "Car Deposit", amount: 231.17, category: "Car", date: "2024-05-31T15:30:00", targetAmount: 54190.0 },
    { id: "9", title: "House Deposit", amount: 133.91, category: "Car", date: "2024-05-09T10:00:00", targetAmount: 54190.0 },
    { id: "10", title: "Wedding Deposit", amount: 183.32, category: "Wedding", date: "2024-11-15T18:45:00", targetAmount: 14190.0 },
    { id: "11", title: "Wedding Deposit", amount: 183.32, category: "Wedding", date: "2024-09-20T20:00:00", targetAmount: 14190.0 },
    { id: "12", title: "Wedding Deposit", amount: 183.32, category: "Wedding", date: "2024-09-15T19:00:00", targetAmount: 14190.0 }
  ];
  for (const saving of savings) {
    await db.collection('savings').doc(saving.id).set(saving);
  }

  console.log('Firestore database populated successfully!');
}

populate();