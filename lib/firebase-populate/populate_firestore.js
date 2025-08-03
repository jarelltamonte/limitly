const admin = require('firebase-admin');

// Initialize Firebase Admin with your project configuration
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://limitly-f5acc-default-rtdb.firebaseio.com"
});

const db = admin.firestore();

// Demo data
const expenseCategories = [
  "Food", "Transport", "Health", "Shopping", "Rent", "Gift", "Savings", "Entertainment"
];

const expenses = [
  {
    id: "1",
    title: "Dinner",
    amount: 26.00,
    category: "Food",
    date: "2024-04-30T18:27:00.000Z",
  },
  {
    id: "2",
    title: "Delivery Pizza",
    amount: 18.35,
    category: "Food",
    date: "2024-04-24T15:00:00.000Z",
  },
  {
    id: "3",
    title: "Lunch",
    amount: 15.40,
    category: "Food",
    date: "2024-04-15T12:30:00.000Z",
  },
  {
    id: "4",
    title: "Brunch",
    amount: 12.13,
    category: "Food",
    date: "2024-04-08T08:30:00.000Z",
  },
  {
    id: "5",
    title: "Dinner",
    amount: 27.20,
    category: "Food",
    date: "2024-03-31T20:50:00.000Z",
  },
  {
    id: "6",
    title: "Bus Fare",
    amount: 2.50,
    category: "Transport",
    date: "2024-04-30T09:00:00.000Z",
  },
  {
    id: "7",
    title: "Gas",
    amount: 45.00,
    category: "Transport",
    date: "2024-04-28T14:30:00.000Z",
  },
  {
    id: "8",
    title: "Doctor Visit",
    amount: 150.00,
    category: "Health",
    date: "2024-04-25T10:00:00.000Z",
  },
  {
    id: "9",
    title: "Shopping",
    amount: 89.99,
    category: "Shopping",
    date: "2024-04-22T16:45:00.000Z",
  },
  {
    id: "10",
    title: "Rent",
    amount: 1200.00,
    category: "Rent",
    date: "2024-04-01T00:00:00.000Z",
  }
];

const savingsCategories = [
  { name: "Travel", targetAmount: 20000.0 },
  { name: "House", targetAmount: 500250.0 },
  { name: "Car", targetAmount: 54190.0 },
  { name: "Wedding", targetAmount: 14190.0 }
];

const savings = [
  {
    id: "1",
    title: "Travel Deposit",
    amount: 231.17,
    category: "Travel",
    date: "2024-04-30T16:00:00.000Z",
    targetAmount: 20000.0,
  },
  {
    id: "2",
    title: "Travel Deposit",
    amount: 231.17,
    category: "Travel",
    date: "2024-04-14T17:00:00.000Z",
    targetAmount: 20000.0,
  },
  {
    id: "3",
    title: "Travel Deposit",
    amount: 191.17,
    category: "Travel",
    date: "2024-04-02T13:20:00.000Z",
    targetAmount: 20000.0,
  },
  {
    id: "4",
    title: "House Deposit",
    amount: 231.17,
    category: "House",
    date: "2024-04-01T19:55:00.000Z",
    targetAmount: 500250.0,
  },
  {
    id: "5",
    title: "House Deposit",
    amount: 231.17,
    category: "House",
    date: "2024-01-18T20:20:00.000Z",
    targetAmount: 500250.0,
  },
  {
    id: "6",
    title: "House Deposit",
    amount: 163.14,
    category: "House",
    date: "2024-01-10T19:00:00.000Z",
    targetAmount: 500250.0,
  },
  {
    id: "7",
    title: "Car Deposit",
    amount: 231.17,
    category: "Car",
    date: "2024-07-01T12:00:00.000Z",
    targetAmount: 54190.0,
  },
  {
    id: "8",
    title: "Car Deposit",
    amount: 231.17,
    category: "Car",
    date: "2024-05-31T15:30:00.000Z",
    targetAmount: 54190.0,
  },
  {
    id: "9",
    title: "Car Deposit",
    amount: 133.91,
    category: "Car",
    date: "2024-05-09T10:00:00.000Z",
    targetAmount: 54190.0,
  },
  {
    id: "10",
    title: "Wedding Deposit",
    amount: 183.32,
    category: "Wedding",
    date: "2024-11-15T18:45:00.000Z",
    targetAmount: 14190.0,
  },
  {
    id: "11",
    title: "Wedding Deposit",
    amount: 183.32,
    category: "Wedding",
    date: "2024-09-20T20:00:00.000Z",
    targetAmount: 14190.0,
  },
  {
    id: "12",
    title: "Wedding Deposit",
    amount: 183.32,
    category: "Wedding",
    date: "2024-09-15T19:00:00.000Z",
    targetAmount: 14190.0,
  }
];

async function populateFirestore() {
  try {
    console.log('Starting Firebase population for limitly-f5acc project...');

    // Clear existing data
    console.log('Clearing existing data...');
    const collections = ['expense_categories', 'expenses', 'savings_categories', 'savings'];
    
    for (const collectionName of collections) {
      const snapshot = await db.collection(collectionName).get();
      const batch = db.batch();
      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
      await batch.commit();
      console.log(`Cleared ${collectionName}`);
    }

    // Populate expense categories
    console.log('Adding expense categories...');
    for (const category of expenseCategories) {
      await db.collection('expense_categories').add({ name: category });
    }
    console.log(`Added ${expenseCategories.length} expense categories`);

    // Populate expenses
    console.log('Adding expenses...');
    for (const expense of expenses) {
      await db.collection('expenses').doc(expense.id).set(expense);
    }
    console.log(`Added ${expenses.length} expenses`);

    // Populate savings categories
    console.log('Adding savings categories...');
    for (const category of savingsCategories) {
      await db.collection('savings_categories').add(category);
    }
    console.log(`Added ${savingsCategories.length} savings categories`);

    // Populate savings
    console.log('Adding savings...');
    for (const saving of savings) {
      await db.collection('savings').doc(saving.id).set(saving);
    }
    console.log(`Added ${savings.length} savings`);

    console.log('Firebase population completed successfully!');
    console.log('Your Firebase project should now have:');
    console.log(`- ${expenseCategories.length} expense categories`);
    console.log(`- ${expenses.length} expenses`);
    console.log(`- ${savingsCategories.length} savings categories`);
    console.log(`- ${savings.length} savings`);
    
    process.exit(0);
  } catch (error) {
    console.error('Error populating Firebase:', error);
    process.exit(1);
  }
}

populateFirestore();
