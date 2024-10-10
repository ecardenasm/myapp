import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/login_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCZ0pMU7V0SuegamkHWoUjppb30bONcIIg",
      authDomain: "campus-comerce.firebaseapp.com",
      projectId: "campus-comerce",
      storageBucket: "campus-comerce.appspot.com",
      messagingSenderId: "143962450086",
      appId: "1:143962450086:web:589a89ad3b32f7373d6c67"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAMPUS COMERCE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}


