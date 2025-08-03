# Firebase Setup Guide

## Current Issues Fixed:

1. ✅ **Firebase Configuration** - Updated to match your web config
2. ✅ **Dashboard Navigation** - Fixed home page showing categories instead of home content
3. ✅ **Default Tab** - Changed from Categories (index 3) to Home (index 0)
4. ✅ **Error Handling** - Added comprehensive debugging and fallback data

## Manual Firebase Data Setup

Since the automated script requires service account credentials, here's how to manually populate your Firebase:

### 1. Go to Firebase Console
- Visit: https://console.firebase.google.com/project/limitly-f5acc
- Navigate to Firestore Database

### 2. Create Collections and Documents

#### Expense Categories Collection
Create collection: `expense_categories`
Add documents with fields:
- `name` (string): "Food", "Transport", "Health", "Shopping", "Rent", "Gift", "Savings", "Entertainment"

#### Expenses Collection  
Create collection: `expenses`
Add documents with fields:
- `id` (string): "1", "2", "3", etc.
- `title` (string): "Dinner", "Lunch", etc.
- `amount` (number): 26.00, 18.35, etc.
- `category` (string): "Food", "Transport", etc.
- `date` (string): "2024-04-30T18:27:00.000Z"

#### Savings Categories Collection
Create collection: `savings_categories`
Add documents with fields:
- `name` (string): "Travel", "House", "Car", "Wedding"
- `targetAmount` (number): 20000.0, 500250.0, 54190.0, 14190.0

#### Savings Collection
Create collection: `savings`
Add documents with fields:
- `id` (string): "1", "2", "3", etc.
- `title` (string): "Travel Deposit", "House Deposit", etc.
- `amount` (number): 231.17, 191.17, etc.
- `category` (string): "Travel", "House", etc.
- `date` (string): "2024-04-30T16:00:00.000Z"
- `targetAmount` (number): 20000.0, 500250.0, etc.

### 3. Sample Data

#### Expense Categories (8 documents):
- Food
- Transport  
- Health
- Shopping
- Rent
- Gift
- Savings
- Entertainment

#### Expenses (10 documents):
1. Dinner - ₱26.00 - Food
2. Delivery Pizza - ₱18.35 - Food
3. Lunch - ₱15.40 - Food
4. Brunch - ₱12.13 - Food
5. Dinner - ₱27.20 - Food
6. Bus Fare - ₱2.50 - Transport
7. Gas - ₱45.00 - Transport
8. Doctor Visit - ₱150.00 - Health
9. Shopping - ₱89.99 - Shopping
10. Rent - ₱1200.00 - Rent

#### Savings Categories (4 documents):
- Travel (₱20,000 target)
- House (₱500,250 target)
- Car (₱54,190 target)
- Wedding (₱14,190 target)

#### Savings (12 documents):
- Various deposits for each category

## Testing the App

1. **Run the app**: `flutter run -d web-server`
2. **Login**: Use any email/password (demo mode)
3. **Check tabs**:
   - Home (index 0) - Should show home content
   - Statistics (index 1) - Should show analysis
   - Transactions (index 2) - Should show transactions
   - Categories (index 3) - Should show expense categories
   - Savings (index 4) - Should show savings categories
   - Profile (index 5) - Should show profile options

## Debug Information

The app now includes comprehensive logging. Check the console for:
- Firebase connection status
- Data loading progress
- Error messages
- Fallback to demo data

## Expected Behavior

- **Home Page**: Shows welcome message and recent transactions
- **Categories**: Shows expense categories with totals
- **Savings**: Shows savings categories with progress
- **Statistics**: Shows live charts and progress
- **Transactions**: Shows chronological list of all transactions
- **Profile**: Shows user information and settings

If data still doesn't load, the app will fall back to demo data automatically. 