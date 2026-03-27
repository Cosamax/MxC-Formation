// ============================================================
// LEGAL QUEST — Carte des modules (vue d'ensemble du parcours)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_theme.dart';
import '../providers/game_provider.dart';
import 'question_screen.dart';
import 'leaderboard_screen.dart';

class ModuleMapScreen extends StatelessWidget {
  const ModuleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            );
          });
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppTheme.navyGradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, game),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        children: [
                          if (game.session != null && game.gameMode == 'team')
                            _buildScoreBar(game),
                          const SizedBox(height: 16),
                          _buildProgressBar(game),
                          const SizedBox(height: 24),
                          ...List.generate(
                            game.modules.length,
                            (i) => _buildModuleCard(context, game, i),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showQuitDialog(context, game),
            icon: const Icon(Icons.close, color: AppTheme.textMuted),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'PARCOURS JURIDIQUE',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'DIGIT\'SHOP avec Léa',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
            icon: const Icon(Icons.emoji_events, color: AppTheme.gold),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(GameProvider game) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.navyAccent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SCORES ACTUELS',
            style: TextStyle(
              color: AppTheme.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ...game.rankedTeams.asMap().entries.map((e) {
            final rank = e.key;
            final team = e.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Text(
                    rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '  ',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      team.name,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${team.score} pts',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressBar(GameProvider game) {
    final total = game.modules.length;
    final current = game.currentModuleIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Module ${current + 1} / $total',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            Text(
              '${(game.gameProgress * 100).round()}% complété',
              style: const TextStyle(
                color: AppTheme.gold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: game.gameProgress,
            minHeight: 8,
            backgroundColor: AppTheme.navyAccent,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.gold),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(
      BuildContext context, GameProvider game, int index) {
    final module = game.modules[index];
    final isCurrent = index == game.currentModuleIndex;
    final isCompleted = index < game.currentModuleIndex;
    final isLocked = index > game.currentModuleIndex;
    final color = ModuleColors.forModule(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isLocked
            ? null
            : () {
                if (isCurrent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const QuestionScreen()),
                  );
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isCurrent
                ? LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.3),
                      AppTheme.cardBg,
                    ],
                  )
                : null,
            color: isCurrent ? null : AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCurrent
                  ? AppTheme.gold
                  : isCompleted
                      ? AppTheme.success.withValues(alpha: 0.4)
                      : AppTheme.divider,
              width: isCurrent ? 2 : 1,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icône module
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppTheme.navyAccent
                      : isCompleted
                          ? AppTheme.success.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isLocked
                        ? AppTheme.divider
                        : isCompleted
                            ? AppTheme.success
                            : color,
                  ),
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock,
                          color: AppTheme.textMuted, size: 22)
                      : isCompleted
                          ? const Icon(Icons.check_circle,
                              color: AppTheme.success, size: 28)
                          : Text(
                              module.icon,
                              style: const TextStyle(fontSize: 26),
                            ),
                ),
              ),
              const SizedBox(width: 14),
              // Info module
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isCurrent)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.gold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'EN COURS',
                              style: TextStyle(
                                color: AppTheme.navyDark,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            module.title,
                            style: TextStyle(
                              color: isLocked
                                  ? AppTheme.textMuted
                                  : AppTheme.textLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      module.subtitle,
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Flèche / durée
              Column(
                children: [
                  Text(
                    '${module.durationMinutes}min',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${module.questions.length} Q',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  if (isCurrent)
                    const Icon(
                      Icons.chevron_right,
                      color: AppTheme.gold,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.navyMid,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Quitter la partie ?',
          style: TextStyle(color: AppTheme.textLight),
        ),
        content: const Text(
          'Votre progression sera perdue.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              game.resetGame();
              Navigator.pop(ctx);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }
}
