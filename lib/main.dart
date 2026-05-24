import 'package:final_project/cart_page.dart';
import 'package:final_project/register_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
// import 'converter_page.dart';// This tells Dart to look in the same folder

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url: '',
  //   anonKey:
  //       '',
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(), // Matches the name in Home_page.dart
    );
  }
}
