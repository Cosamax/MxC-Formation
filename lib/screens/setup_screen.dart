// ============================================================
// LEGAL QUEST — Écran de configuration des équipes
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_theme.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import 'module_map_screen.dart';

class SetupScreen extends StatefulWidget {
  final bool isSolo;
  const SetupScreen({super.key, required this.isSolo});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _teamCount = 2;
  final List<TextEditingController> _nameControllers = [];

  final List<String> _defaultTeamNames = [
    'Équipe Juris',
    'Équipe Lex',
    'Équipe Codex',
    'Équipe Droit',
  ];

  final List<String> _teamEmojis = ['⚖️', '🔒', '📋', '🌐'];

  @override
  void initState() {
    super.initState();
    if (widget.isSolo) {
      _teamCount = 1;
      _nameControllers.add(TextEditingController(text: 'Joueur Solo'));
    } else {
      for (int i = 0; i < 4; i++) {
        _nameControllers.add(
          TextEditingController(text: _defaultTeamNames[i]),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.navyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      if (!widget.isSolo) _buildTeamCountSelector(),
                      const SizedBox(height: 24),
                      _buildTeamFields(),
                      const SizedBox(height: 32),
                      _buildStartButton(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.gold),
          ),
          const Expanded(
            child: Text(
              'CONFIGURATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTeamCountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOMBRE D\'ÉQUIPES',
          style: TextStyle(
            color: AppTheme.gold,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [2, 3, 4].map((count) {
            final selected = _teamCount == count;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () => setState(() => _teamCount = count),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.gold : AppTheme.navyAccent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppTheme.gold : AppTheme.divider,
                      width: 2,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppTheme.gold.withValues(alpha: 0.3),
                              blurRadius: 12,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$count',
                        style: TextStyle(
                          color: selected ? AppTheme.navyDark : AppTheme.textLight,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        count == 1 ? 'équipe' : 'équipes',
                        style: TextStyle(
                          color: selected
                              ? AppTheme.navyDark
                              : AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTeamFields() {
    final count = widget.isSolo ? 1 : _teamCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isSolo ? 'VOTRE NOM' : 'NOMS DES ÉQUIPES',
          style: const TextStyle(
            color: AppTheme.gold,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(count, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.navyAccent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      _teamEmojis[i],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nameControllers[i],
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.isSolo
                            ? 'Votre prénom'
                            : 'Nom de l\'équipe ${i + 1}',
                        hintStyle: const TextStyle(color: AppTheme.textMuted),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.navyAccent.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('⏱️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Durée estimée : ~3 heures',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '6 modules · ${widget.isSolo ? '1 joueur' : '$_teamCount équipes'}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _startGame(context),
            icon: const Icon(Icons.play_arrow_rounded, size: 26),
            label: const Text('LANCER LE JEU'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              foregroundColor: AppTheme.navyDark,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: AppTheme.gold.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  void _startGame(BuildContext context) {
    final count = widget.isSolo ? 1 : _teamCount;
    final teams = List.generate(
      count,
      (i) => Team(
        id: 'team_$i',
        name: _nameControllers[i].text.trim().isEmpty
            ? (widget.isSolo ? 'Joueur' : 'Équipe ${i + 1}')
            : _nameControllers[i].text.trim(),
      ),
    );

    context.read<GameProvider>().initGame(
          teams: teams,
          mode: widget.isSolo ? 'solo' : 'team',
        );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ModuleMapScreen()),
      (route) => route.isFirst,
    );
  }
}
