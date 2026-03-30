import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Platform imports
import 'platform/models/platform_theme.dart';
import 'platform/providers/platform_provider.dart';
import 'platform/screens/auth/auth_screen.dart';
import 'platform/screens/catalog/game_catalog_screen.dart';
import 'platform/screens/professor/professor_dashboard.dart';
import 'platform/screens/landing/landing_page.dart';
import 'games/droit_internet/models/game_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Charger les soumissions persistées avant le lancement de l'app
  await SubmissionManager.instance.load();
  runApp(const MxCFormationsApp());
}

class MxCFormationsApp extends StatelessWidget {
  const MxCFormationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlatformProvider()),
      ],
      child: MaterialApp(
        title: 'MxC Formations',
        debugShowCheckedModeBanner: false,
        theme: MxCTheme.theme,
        home: const PlatformShell(),
        routes: {
          '/landing': (ctx) => const LandingPage(),
          '/auth': (ctx) => const AuthScreen(),
          '/catalog': (ctx) => const GameCatalogScreen(),
          '/professor': (ctx) => const ProfessorDashboard(),
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHELL PRINCIPAL — Router intelligent
// ═══════════════════════════════════════════════════════════════

class PlatformShell extends StatelessWidget {
  const PlatformShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlatformProvider>(
      builder: (context, provider, _) {
        // Non connecté → Page façade
        if (!provider.isLoggedIn) {
          return const LandingPage();
        }

        // Formateur/Coach → Dashboard
        if (provider.isProfessor) {
          return const ProfessorDashboard();
        }

        // Apprenant → Catalogue des jeux
        return const GameCatalogScreen();
      },
    );
  }
}
