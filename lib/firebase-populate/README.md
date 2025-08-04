# Firebase Data Population

This directory contains utilities for populating Firebase Firestore with sample data.

## Files

- `sample_data.json` - Sample data for the Limitly app (expenses, savings, categories, users)
- `import_sample_data.js` - Script to import sample data to a Firebase project

## Usage

If you need to populate a new Firebase project with sample data:

1. Download a service account key from your Firebase project
2. Save it as `new-project-key.json` in this directory
3. Update the project ID in `import_sample_data.js`
4. Run: `node import_sample_data.js`

## Sample Data Includes

- **8 Expense Categories**: Food, Transport, Health, Shopping, Rent, Gift, Savings, Entertainment
- **10 Sample Expenses**: Various expenses across different categories
- **4 Savings Categories**: Travel, House, Car, Wedding with target amounts
- **12 Sample Savings**: Deposits for different savings goals
- **1 Demo User**: Sample user account

## Security Note

Service account keys should never be committed to version control. They are excluded via `.gitignore`. 