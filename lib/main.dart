import 'package:final_project/cart_page.dart';
import 'package:final_project/register_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
// import 'converter_page.dart';// This tells Dart to look in the same folder

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ucgwefllueigvqmzxdyg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjZ3dlZmxsdWVpZ3ZxbXp4ZHlnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MDk3MjMsImV4cCI6MjA5MzI4NTcyM30.UBKUgQCCNrwMc7pr2eYgD4Ea3Mu3rRay4_dYL4jaMSY',
  );
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
