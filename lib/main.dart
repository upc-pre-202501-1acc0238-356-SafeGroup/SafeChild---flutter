import 'package:flutter/material.dart';
import 'nav/navigator.dart';
import 'views/chat_list_screen.dart';

void main() {
  runApp(const SafeChildApp());
}

class SafeChildApp extends StatelessWidget {
  const SafeChildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeChild - Mensajería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppNavigator.generateRoute,
      home: const ChatListScreen(userId: 1),
    );
  }
}

