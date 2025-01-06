# 🔥 backend-atts: Powering Atts Super Market

Welcome to the backend of Atts Super Market! This README will guide you through setting up our Firebase-powered backend for your Flutter app across Android, iOS, and Windows. Let's get this show on the road!

## 🚀 What's in the Box?

Our backend is using Firebase, specifically:
- Cloud Firestore: Our turbocharged database for all your supermarket needs

## 🛠️ Setting Up Firebase

1. Head over to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and name it "backend-atts" (or whatever cool name you chose)
3. Follow the prompts to set up your project
4. Once created, click on "Firestore Database" in the left sidebar
5. Click "Create database", choose "Start in production mode", and select a location close to your users

## 🎯 Flutter Setup: Android, iOS, and Windows

### Prerequisites
- Flutter SDK installed
- An IDE (Android Studio, VS Code, etc.)
- Firebase CLI installed (`npm install -g firebase-tools`)

### Let's Do This!

1. Create your Flutter project (if you haven't already):
   ```
   flutter create atts_super_market
   cd atts_super_market
   ```

2. Add Firebase to your Flutter project:
   ```
   dart pub global activate flutterfire_cli
   flutterfire configure --project=backend-atts
   ```
   This command will guide you through selecting platforms (Android, iOS, Windows) and download necessary config files.

3. Add Firebase dependencies to your `pubspec.yaml`:
   ```yaml
   dependencies:
     firebase_core: ^2.15.1
     cloud_firestore: ^4.9.1
   ```

4. Run `flutter pub get` to install the dependencies

5. Initialize Firebase in your `main.dart`:
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(MyApp());
   }
   ```

### Platform-Specific Steps

#### Android
- No additional steps needed! The `flutterfire configure` command took care of everything.

#### iOS
- Open your iOS project in Xcode:
  ```
  open ios/Runner.xcworkspace
  ```
- In Xcode, using the top menu: File > Add Packages
- Search for "firebase-ios-sdk" and add the Firebase iOS SDK

#### Windows
- The `flutterfire configure` command should have set everything up
- If you encounter any issues, ensure your Windows project is properly configured for Firebase

## 🔥 Using Cloud Firestore

Now that you're all set up, here's a quick example of how to use Cloud Firestore in your Flutter app:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Add a new item
Future<void> addItem(String name, double price) {
  return FirebaseFirestore.instance.collection('items').add({
    'name': name,
    'price': price,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

// Read items
Stream<QuerySnapshot> getItems() {
  return FirebaseFirestore.instance.collection('items').snapshots();
}
```

## 🚨 Troubleshooting

- If you see a "MissingPluginException", try:
  ```
  flutter clean
  flutter pub get
  ```
- For Windows-specific issues, ensure you have the latest Flutter and Firebase packages

## 🎉 You're All Set!

Congratulations! You've successfully set up the backend for Atts Super Market. Now go forth and create an amazing supermarket management app!

Need help? Don't hesitate to reach out or check the [Firebase Flutter documentation](https://firebase.flutter.dev/docs/overview/).

Happy coding! 🚀🛒💻