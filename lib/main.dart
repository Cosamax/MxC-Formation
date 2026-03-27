// ============================================================
// LEGAL QUEST — Main Entry Point
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_theme.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LegalQuestApp());
}

class LegalQuestApp extends StatelessWidget {
  const LegalQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Legal Quest — DIGIT\'SHOP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
