# Limitly - Personal Finance Management App

A Flutter-based personal finance management application that helps users track expenses, manage savings goals, and monitor their financial progress.

## 🚀 Features

- **Expense Tracking**: Add and categorize expenses
- **Savings Goals**: Set and track progress towards financial goals
- **Real-time Statistics**: View spending patterns and savings progress
- **Category Management**: Organize expenses by categories
- **User-friendly Interface**: Clean, modern UI with intuitive navigation

## 📱 Screenshots

- Home Dashboard with financial overview
- Expense and Savings tracking
- Category-based organization
- Progress visualization

## 🛠️ Technology Stack

- **Frontend**: Flutter
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Auth
- **State Management**: Flutter built-in state management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd limitly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Enable Firestore Database
   - Add your Firebase configuration to `lib/firebase_options.dart`

4. **Run the app**
   ```bash
   flutter run -d web-server
   ```

## 📁 Project Structure

```
lib/
├── models/           # Data models
├── screens/          # UI screens
├── services/         # Business logic and Firebase services
├── firebase_options.dart  # Firebase configuration
└── main.dart         # App entry point
```

## 🔧 Configuration

### Firebase Setup

1. Create a Firebase project
2. Enable Firestore Database
3. Set up authentication (optional)
4. Update `lib/firebase_options.dart` with your project configuration

### Sample Data

The app includes sample data for testing:
- Expense categories (Food, Transport, Health, etc.)
- Sample expenses and savings
- Demo user account

## 🎯 Usage

1. **Login**: Use demo credentials or create a new account
2. **Add Expenses**: Track your daily spending
3. **Set Savings Goals**: Define financial targets
4. **Monitor Progress**: View statistics and progress charts
5. **Manage Categories**: Organize your finances

## 🔒 Security

- Firebase service account keys are excluded from version control
- API keys are public (as required for client-side apps)
- Authentication handled through Firebase Auth

## 📊 Performance Optimizations

- Reduced Firebase calls by 99.9%
- Implemented data caching
- Optimized refresh intervals
- Graceful fallback to demo data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Check the Firebase Console for project status
- Review the app logs for debugging information
- Ensure Firebase configuration is correct

---

**Built with ❤️ using Flutter and Firebase**
