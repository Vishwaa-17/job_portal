import 'package:careers/main_wrapper.dart';
import 'package:careers/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:careers/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDpAhn3_Vw8BR_A94FLnIyihd-2PKNyweE',
        appId: '1:676333322217:web:523b441ee783c0a6b6d578',
        messagingSenderId: '676333322217',
        projectId: 'careers-7584c',
        storageBucket: 'careers-7584c.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Careers',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const MainWrapper(), // 👈 This replaces StreamBuilder
    );
  }
}
