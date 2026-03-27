// ============================================================
// LEGAL QUEST — Écran d'accueil
// ============================================================

import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import 'setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.navyGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildLogo(),
                    const SizedBox(height: 32),
                    _buildHero(),
                    const SizedBox(height: 40),
                    _buildGameInfo(),
                    const SizedBox(height: 40),
                    _buildStartButtons(context),
                    const SizedBox(height: 32),
                    _buildBottomInfo(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.goldGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text('⚖️', style: TextStyle(fontSize: 44)),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.goldGradient.createShader(bounds),
          child: const Text(
            'LEGAL QUEST',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'DIGIT\'SHOP — LE JEU DU DROIT',
            style: TextStyle(
              color: AppTheme.gold,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('👩‍💼', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LÉANE VOUS ATTEND !',
                      style: TextStyle(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fondatrice de DIGIT\'SHOP, elle a besoin de votre expertise juridique pour faire prospérer sa boutique en ligne.',
                      style: TextStyle(
                        color: AppTheme.textLight.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 12),
          const Text(
            '"Guidez Léa à travers 6 modules juridiques, relevez les défis, évitez les sanctions et construisez l\'e-commerce parfaitement conforme !"',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LE JEU EN CHIFFRES',
          style: TextStyle(
            color: AppTheme.gold,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.0,
          children: [
            _infoCard('⏱️', '3h', 'de jeu'),
            _infoCard('📚', '6', 'modules'),
            _infoCard('❓', '29', 'questions'),
            _infoCard('👥', '1-4', 'équipes'),
            _infoCard('📋', '20', 'fiches'),
            _infoCard('🏆', '∞', 'points'),
          ],
        ),
      ],
    );
  }

  Widget _infoCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.navyAccent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SetupScreen(isSolo: true),
                ),
              );
            },
            icon: const Icon(Icons.person, size: 22),
            label: const Text('JOUER EN SOLO'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              foregroundColor: AppTheme.navyDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SetupScreen(isSolo: false),
                ),
              );
            },
            icon: const Icon(Icons.group, size: 22),
            label: const Text('MODE ÉQUIPE (2-4)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.gold,
              side: const BorderSide(color: AppTheme.gold, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _showRulesDialog(context),
          child: const Text(
            '📖 RÈGLES DU JEU',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.navyAccent.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Text('🎓', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Mastère Européen E-Business\nUC D51.2 — Droit de l\'Internet et du E-Commerce',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.navyMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  const Text(
                    'RÈGLES DU JEU',
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._rulesSections.map((s) => _ruleSection(s[0], s[1])),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('COMPRIS !'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ruleSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const Divider(color: AppTheme.divider),
        ],
      ),
    );
  }

  static const List<List<String>> _rulesSections = [
    [
      '⏱️ DURÉE',
      'La partie complète dure environ 3 heures. Chaque module dure 20-30 minutes. Jouez à votre rythme ou en time-boxing strict.',
    ],
    [
      '🎮 MODES DE JEU',
      'SOLO : Progressez seul à travers les 6 modules. Votre score final évalue votre maîtrise du cours.\n\nÉQUIPE (2-4) : Les équipes se disputent chaque question à tour de rôle. L\'équipe avec le plus de points à la fin gagne !',
    ],
    [
      '📊 SYSTÈME DE POINTS',
      '• Questions faciles : 80-100 pts\n• Questions moyennes : 120-160 pts\n• Questions difficiles : 180-200 pts\n• Scénarios / Grand Final : 200-400 pts\n• Bonus vitesse : jusqu\'à +50 pts si réponse rapide\n• Série correcte : badges 🔥 (×3) et ⚡ (×5)',
    ],
    [
      '⏰ CHRONOMÈTRE',
      'Chaque question a un timer. Questions faciles = 20-25s. Questions difficiles = 45-60s. Si le temps expire, aucun point accordé.',
    ],
    [
      '💡 EXPLICATIONS',
      'Après chaque réponse, une explication détaillée avec la référence de la fiche de cours est affichée. Utilisez-la pour consolider vos connaissances !',
    ],
    [
      '🏆 CLASSEMENT',
      'Le leaderboard final affiche les scores, le taux de réussite et les badges obtenus par chaque équipe ou joueur.',
    ],
  ];
}
