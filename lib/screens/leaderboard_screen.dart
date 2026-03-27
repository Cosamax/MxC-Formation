// ============================================================
// LEGAL QUEST — Leaderboard / Écran de fin de partie
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_theme.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import 'home_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final teams = game.rankedTeams;
        final isSolo = game.gameMode == 'solo';
        final isGameOver = game.isGameOver;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppTheme.navyGradient),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    _buildHeader(isGameOver, isSolo),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        child: Column(
                          children: [
                            if (!isSolo && teams.isNotEmpty)
                              _buildPodium(teams),
                            const SizedBox(height: 24),
                            _buildRankingList(teams, isSolo),
                            const SizedBox(height: 24),
                            _buildModuleStats(game),
                            const SizedBox(height: 32),
                            if (isGameOver) _buildButtons(context, game),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isGameOver, bool isSolo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          if (isGameOver) ...[
            const Text('🏆', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (b) =>
                  AppTheme.goldGradient.createShader(b),
              child: const Text(
                'PARTIE TERMINÉE !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSolo
                  ? 'Votre score final'
                  : 'Classement final des équipes',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
          ] else ...[
            const Text(
              '📊 CLASSEMENT INTERMÉDIAIRE',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPodium(List<Team> teams) {
    if (teams.length < 2) return const SizedBox();
    final heights = [120.0, 90.0, 70.0, 60.0];
    final medals = ['🥇', '🥈', '🥉', '4️⃣'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          const Text(
            'PODIUM',
            style: TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: teams.take(4).toList().asMap().entries.map((e) {
              final i = e.key;
              final team = e.value;
              final h = i < heights.length ? heights[i] : 50.0;
              final medal = i < medals.length ? medals[i] : '';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(medal,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(
                        team.name,
                        style: const TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${team.score}',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: h,
                        decoration: BoxDecoration(
                          gradient: i == 0
                              ? AppTheme.goldGradient
                              : LinearGradient(
                                  colors: [
                                    AppTheme.navyLight,
                                    AppTheme.navyAccent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList(List<Team> teams, bool isSolo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSolo ? 'VOTRE PERFORMANCE' : 'CLASSEMENT DÉTAILLÉ',
          style: const TextStyle(
            color: AppTheme.gold,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        ...teams.asMap().entries.map((e) {
          final rank = e.key;
          final team = e.value;
          return _buildTeamRow(rank, team, teams.length == 1);
        }),
      ],
    );
  }

  Widget _buildTeamRow(int rank, Team team, bool isSolo) {
    final medals = ['🥇', '🥈', '🥉'];
    final medal = rank < medals.length ? medals[rank] : '${rank + 1}.';

    final accuracy = (team.accuracy * 100).round();
    final accuracyColor = accuracy >= 75
        ? AppTheme.success
        : accuracy >= 50
            ? AppTheme.warning
            : AppTheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: rank == 0 && !isSolo
            ? LinearGradient(
                colors: [
                  AppTheme.gold.withValues(alpha: 0.15),
                  AppTheme.cardBg,
                ],
              )
            : null,
        color: rank == 0 && !isSolo ? null : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rank == 0 && !isSolo
              ? AppTheme.gold.withValues(alpha: 0.5)
              : AppTheme.divider,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(medal, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${team.correctAnswers} / ${team.totalAnswered} bonnes réponses',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${team.score} pts',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$accuracy% réussite',
                    style: TextStyle(
                      color: accuracyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (team.badges.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(color: AppTheme.divider),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: team.badges
                  .toSet()
                  .map((b) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                AppTheme.warning.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          b,
                          style: const TextStyle(
                            color: AppTheme.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 10),
          // Barre de précision
          Row(
            children: [
              const Text(
                'Précision',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: team.accuracy,
                    minHeight: 6,
                    backgroundColor: AppTheme.navyAccent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(accuracyColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$accuracy%',
                style: TextStyle(
                  color: accuracyColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleStats(GameProvider game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MODULES DU COURS COUVERTS',
            style: TextStyle(
              color: AppTheme.gold,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...game.modules.asMap().entries.map((e) {
            final i = e.key;
            final mod = e.value;
            final completed = i < game.currentModuleIndex ||
                (i == game.currentModuleIndex &&
                    game.currentQuestionIndex >= mod.questions.length - 1);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(completed ? '✅' : '⏸️',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(
                    mod.icon,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mod.title,
                      style: TextStyle(
                        color: completed
                            ? AppTheme.textLight
                            : AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    mod.subtitle,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
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

  Widget _buildButtons(BuildContext context, GameProvider game) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              game.resetGame();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.home_rounded),
            label: const Text('RETOUR À L\'ACCUEIL'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Reset game avec mêmes équipes
              final teams = game.session?.teams
                      .map((t) => Team(id: t.id, name: t.name))
                      .toList() ??
                  [];
              game.initGame(
                teams: teams,
                mode: game.gameMode,
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.replay_rounded),
            label: const Text('REJOUER'),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.navyAccent.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider),
          ),
          child: const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Revoyez les fiches correspondant aux réponses manquées pour consolider vos connaissances !',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
