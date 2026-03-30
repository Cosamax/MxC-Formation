import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/platform_provider.dart';
import '../../models/platform_theme.dart';
import '../../models/platform_models.dart';
import '../../data/games_data.dart';
import '../../../games/droit_internet/nexova_game.dart';
import '../../../games/clarity_zone/clarity_game.dart';
import '../../../games/droit_internet/data/challenges_data.dart';
import '../../../games/droit_internet/models/game_models.dart';
import '../../services/editor_persistence_service.dart';
import '../../services/game_save_service.dart';

class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({super.key});

  @override
  State<ProfessorDashboard> createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MxCTheme.background,
      bottomNavigationBar: _buildBottomNav(),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const _OverviewTab(),
          const _GamesTab(),
          const _LearnersTab(),
          const _SessionsTab(),
          const _EditorTab(),
          const _ValidationsTab(),
          _SettingsTab(
            onGoToEditor: () => setState(() => _selectedTab = 4),
            onGoToValidations: () => setState(() => _selectedTab = 5),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: MxCTheme.surface,
        border: Border(top: BorderSide(color: MxCTheme.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: MxCTheme.primary,
        unselectedItemColor: MxCTheme.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games_outlined),
            activeIcon: Icon(Icons.games),
            label: 'Jeux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people),
            label: 'Apprenants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            activeIcon: Icon(Icons.play_circle),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note),
            label: 'Éditeur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            activeIcon: Icon(Icons.rate_review),
            label: 'Validations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Réglages',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET VUE D'ENSEMBLE
// ═══════════════════════════════════════════════════════════════

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlatformProvider>();
    final stats = provider.professorStats;
    final user = provider.currentUser;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(user),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIGrid(stats),
                  const SizedBox(height: 24),
                  const Text(
                    'Résultats récents',
                    style: TextStyle(
                      color: MxCTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRecentResults(provider.allResults),
                  const SizedBox(height: 24),
                  const Text(
                    'Performance par jeu',
                    style: TextStyle(
                      color: MxCTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGameStats(stats.gameStats),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PlatformUser? user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tableau de bord',
                  style: TextStyle(
                    color: MxCTheme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user?.name ?? 'Formateur',
                  style: const TextStyle(
                    color: MxCTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MxCTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: MxCTheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: MxCTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'En ligne',
                  style: TextStyle(
                    color: MxCTheme.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIGrid(ProfessorStats stats) {
    final kpis = [
      {
        'label': 'Jeux actifs',
        'value': '${stats.totalGames}',
        'icon': Icons.videogame_asset,
        'color': MxCTheme.primary,
      },
      {
        'label': 'Sessions',
        'value': '${stats.totalSessions}',
        'icon': Icons.play_circle,
        'color': MxCTheme.accent,
      },
      {
        'label': 'Apprenants',
        'value': '${stats.totalStudents}',
        'icon': Icons.people,
        'color': MxCTheme.accentWarm,
      },
      {
        'label': 'Score moyen',
        'value': '${stats.avgScore.toStringAsFixed(0)}%',
        'icon': Icons.grade,
        'color': MxCTheme.reputation,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: kpis.length,
      itemBuilder: (_, i) {
        final kpi = kpis[i];
        final color = kpi['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MxCTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(kpi['icon'] as IconData, color: color, size: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kpi['value'] as String,
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    kpi['label'] as String,
                    style: const TextStyle(
                      color: MxCTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentResults(List<StudentResult> results) {
    if (results.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: MxCTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MxCTheme.border),
        ),
        child: const Center(
          child: Text(
            'Aucun résultat pour le moment',
            style: TextStyle(color: MxCTheme.textMuted),
          ),
        ),
      );
    }

    final sorted = List<StudentResult>.from(results)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    final recent = sorted.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MxCTheme.border),
      ),
      child: Column(
        children: recent.asMap().entries.map((e) {
          final r = e.value;
          final isLast = e.key == recent.length - 1;
          final color = r.percentage >= 80
              ? MxCTheme.accent
              : r.percentage >= 60
                  ? MxCTheme.accentWarm
                  : MxCTheme.error;

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text(
                    r.studentName[0].toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                title: Text(
                  r.studentName,
                  style: const TextStyle(
                    color: MxCTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${r.correctAnswers}/${r.totalQuestions} bonnes réponses',
                  style: const TextStyle(
                    color: MxCTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${r.percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                const Divider(height: 1, color: MxCTheme.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameStats(List<GameStat> gameStats) {
    if (gameStats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: MxCTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MxCTheme.border),
        ),
        child: const Center(
          child: Text(
            'Aucune statistique disponible',
            style: TextStyle(color: MxCTheme.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: gameStats.map((stat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MxCTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MxCTheme.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: stat.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    stat.gameTitle,
                    style: const TextStyle(
                      color: MxCTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${stat.avgScore.toStringAsFixed(0)}% moy.',
                    style: TextStyle(
                      color: stat.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: stat.avgScore / 100,
                  backgroundColor: MxCTheme.border,
                  valueColor: AlwaysStoppedAnimation(stat.color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${stat.sessionCount} session(s)',
                    style: const TextStyle(
                      color: MxCTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${stat.studentCount} apprenant(s)',
                    style: const TextStyle(
                      color: MxCTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET JEUX
// ═══════════════════════════════════════════════════════════════

class _GamesTab extends StatelessWidget {
  const _GamesTab();

  @override
  Widget build(BuildContext context) {
    final games = GamesData.catalog;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gestion des Jeux',
                    style: TextStyle(
                      color: MxCTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final game = games[i];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _ProfGameCard(game: game),
                );
              },
              childCount: games.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _ProfGameCard extends StatelessWidget {
  final GameInfo game;
  const _ProfGameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final isAvailable = game.status == GameStatus.published;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable
              ? game.color.withValues(alpha: 0.3)
              : MxCTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: game.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(game.icon, color: game.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        color: MxCTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      game.subtitle,
                      style: const TextStyle(
                        color: MxCTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? MxCTheme.accent.withValues(alpha: 0.15)
                      : MxCTheme.accentWarm.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAvailable ? '✓ Publié' : '⚙ Brouillon',
                  style: TextStyle(
                    color:
                        isAvailable ? MxCTheme.accent : MxCTheme.accentWarm,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip('${game.totalQuestions} questions', Icons.quiz_outlined),
              const SizedBox(width: 8),
              _infoChip('${game.estimatedMinutes} min', Icons.timer_outlined),
              const SizedBox(width: 8),
              _infoChip(game.difficulty, Icons.signal_cellular_alt),
            ],
          ),
          if (isAvailable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showGameDetails(context, game),
                    icon:
                        const Icon(Icons.bar_chart, size: 16),
                    label: const Text('Statistiques'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: game.color,
                      side: BorderSide(
                          color: game.color.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startSession(context, game),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Lancer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: game.color,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _testGame(context, game),
                  icon: const Icon(Icons.videogame_asset, size: 16),
                  label: const Text('Tester'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MxCTheme.primary.withValues(alpha: 0.15),
                    foregroundColor: MxCTheme.primary,
                    elevation: 0,
                    side: BorderSide(color: MxCTheme.primary.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: MxCTheme.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 11, color: MxCTheme.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style:
                const TextStyle(color: MxCTheme.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _startSession(BuildContext context, GameInfo game) {
    final provider = context.read<PlatformProvider>();
    final session = provider.createSession(game.id);

    showDialog(
      context: context,
      builder: (ctx) => _SessionCreatedDialog(
        sessionCode: session.sessionCode,
        gameName: game.title,
        gameColor: game.color,
        onStart: () {
          Navigator.pop(ctx);
          Navigator.pushNamed(context, '/game');
        },
      ),
    );
  }

  void _showGameDetails(BuildContext context, GameInfo game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MxCTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _GameDetailsSheet(game: game),
    );
  }

  void _testGame(BuildContext context, GameInfo game) {
    if (game.id == 'nexova') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NexovaGameHub()),
      );
    } else if (game.id == 'clarity_zone') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ClarityGameHub()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${game.title} — Bientôt disponible !'),
          backgroundColor: MxCTheme.surfaceCard,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

class _SessionCreatedDialog extends StatelessWidget {
  final String sessionCode;
  final String gameName;
  final Color gameColor;
  final VoidCallback onStart;

  const _SessionCreatedDialog({
    required this.sessionCode,
    required this.gameName,
    required this.gameColor,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MxCTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: gameColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: gameColor, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Session créée !',
              style: TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              gameName,
              style: const TextStyle(color: MxCTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Code de session pour les apprenants',
              style: TextStyle(color: MxCTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: gameColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gameColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                sessionCode,
                style: TextStyle(
                  color: gameColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Partagez ce code avec vos apprenants',
              style: TextStyle(color: MxCTheme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: MxCTheme.border),
                    ),
                    child: const Text('Fermer',
                        style: TextStyle(color: MxCTheme.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Lancer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gameColor,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameDetailsSheet extends StatelessWidget {
  final GameInfo game;
  const _GameDetailsSheet({required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(game.icon, color: game.color),
              const SizedBox(width: 12),
              Text(
                game.title,
                style: const TextStyle(
                  color: MxCTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            game.description,
            style: const TextStyle(
              color: MxCTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Compétences couvertes :',
            style: TextStyle(
              color: MxCTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: game.skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: game.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: game.color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        color: game.color,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET APPRENANTS — Gestion des accès
// ═══════════════════════════════════════════════════════════════

class _LearnersTab extends StatefulWidget {
  const _LearnersTab();

  @override
  State<_LearnersTab> createState() => _LearnersTabState();
}

class _LearnersTabState extends State<_LearnersTab> {
  String _search = '';
  String? _filterGameId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlatformProvider>();
    final learners = provider.registeredLearners
        .where((u) =>
            _search.isEmpty ||
            u.name.toLowerCase().contains(_search.toLowerCase()) ||
            u.email.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    final publishedGames = provider.publishedGames;

    return SafeArea(
      child: Column(
        children: [
          // ─── Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Apprenants',
                  style: TextStyle(
                    color: MxCTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: MxCTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: MxCTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${learners.length} inscrit(s)',
                    style: const TextStyle(
                        color: MxCTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ─── Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher un apprenant…',
                hintStyle:
                    const TextStyle(color: Colors.white30, fontSize: 13),
                prefixIcon: const Icon(Icons.search,
                    color: Colors.white38, size: 18),
                filled: true,
                fillColor: MxCTheme.surfaceCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: MxCTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: MxCTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: MxCTheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ─── Liste apprenants
          Expanded(
            child: learners.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline,
                            color: MxCTheme.textMuted, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucun apprenant inscrit',
                          style: TextStyle(
                              color: MxCTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _search.isNotEmpty
                              ? 'Aucun résultat pour "$_search"'
                              : 'Les apprenants inscrits apparaîtront ici',
                          style: const TextStyle(
                              color: MxCTheme.textMuted, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: learners.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (ctx, i) => _LearnerCard(
                      learner: learners[i],
                      publishedGames: publishedGames,
                      onGrantAccess: (gameId) =>
                          provider.grantAccess(learners[i].id, gameId),
                      onRevokeAccess: (gameId) =>
                          provider.revokeAccess(learners[i].id, gameId),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LearnerCard extends StatelessWidget {
  final PlatformUser learner;
  final List<GameInfo> publishedGames;
  final void Function(String) onGrantAccess;
  final void Function(String) onRevokeAccess;

  const _LearnerCard({
    required this.learner,
    required this.publishedGames,
    required this.onGrantAccess,
    required this.onRevokeAccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MxCTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info apprenant
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: learner.color.withValues(alpha: 0.2),
                child: Text(
                  learner.initials,
                  style: TextStyle(
                    color: learner.color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      learner.name,
                      style: const TextStyle(
                        color: MxCTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      learner.email,
                      style: const TextStyle(
                          color: MxCTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Nombre d'accès
              Text(
                '${learner.gameAccesses.length} jeu(x)',
                style: const TextStyle(
                    color: MxCTheme.textSecondary, fontSize: 11),
              ),
            ],
          ),

          if (publishedGames.isNotEmpty) ...[  
            const SizedBox(height: 12),
            const Text(
              'Accès aux jeux :',
              style: TextStyle(
                  color: MxCTheme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: publishedGames.map((game) {
                final hasAccess = learner.hasAccessTo(game.id);
                return GestureDetector(
                  onTap: () => hasAccess
                      ? onRevokeAccess(game.id)
                      : onGrantAccess(game.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: hasAccess
                          ? game.color.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasAccess
                            ? game.color.withValues(alpha: 0.5)
                            : Colors.white12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasAccess
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          size: 13,
                          color: hasAccess ? game.color : Colors.white38,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          game.title,
                          style: TextStyle(
                            color: hasAccess
                                ? game.color
                                : Colors.white38,
                            fontSize: 11,
                            fontWeight: hasAccess
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET SESSIONS
// ═══════════════════════════════════════════════════════════════

class _SessionsTab extends StatelessWidget {
  const _SessionsTab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MxCTheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: MxCTheme.surface,
            child: const TabBar(
              labelColor: MxCTheme.primary,
              unselectedLabelColor: MxCTheme.textMuted,
              indicatorColor: MxCTheme.primary,
              tabs: [
                Tab(text: 'Sessions'),
                Tab(text: 'Progressions'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _SessionsList(),
            _ProgressionsPanel(),
          ],
        ),
      ),
    );
  }
}

class _SessionsList extends StatelessWidget {
  const _SessionsList();

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<PlatformProvider>().sessions;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                'Sessions de jeu',
                style: TextStyle(
                  color: MxCTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          if (sessions.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Icon(Icons.play_circle_outline,
                          color: MxCTheme.textMuted, size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucune session',
                        style: TextStyle(
                          color: MxCTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Lancez un jeu depuis l\'onglet Jeux',
                        style: TextStyle(color: MxCTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final session = sessions[i];
                  final game = GamesData.getById(session.gameId);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _SessionCard(session: session, game: game),
                  );
                },
                childCount: sessions.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final GameSession session;
  final GameInfo? game;

  const _SessionCard({required this.session, this.game});

  @override
  Widget build(BuildContext context) {
    final color = game?.color ?? MxCTheme.primary;
    final avgScore = session.results.isEmpty
        ? 0.0
        : session.results
                .map((r) => r.percentage)
                .reduce((a, b) => a + b) /
            session.results.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: session.isActive
              ? color.withValues(alpha: 0.5)
              : MxCTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  game?.title ?? 'Jeu inconnu',
                  style: const TextStyle(
                    color: MxCTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: session.isActive
                      ? MxCTheme.accent.withValues(alpha: 0.15)
                      : MxCTheme.textMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (session.isActive)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: MxCTheme.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      session.isActive ? 'Active' : 'Terminée',
                      style: TextStyle(
                        color: session.isActive
                            ? MxCTheme.accent
                            : MxCTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip('Code: ${session.sessionCode}', color),
              const SizedBox(width: 8),
              _chip('${session.results.length} apprenants',
                  MxCTheme.textSecondary),
              if (session.results.isNotEmpty) ...[
                const SizedBox(width: 8),
                _chip(
                    'Moy: ${avgScore.toStringAsFixed(0)}%', MxCTheme.accent),
              ],
            ],
          ),
          if (session.results.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Résultats :',
              style: TextStyle(
                color: MxCTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...session.results.take(3).map((r) {
              final pct = r.percentage;
              final c = pct >= 80
                  ? MxCTheme.accent
                  : pct >= 60
                      ? MxCTheme.accentWarm
                      : MxCTheme.error;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: c.withValues(alpha: 0.15),
                      child: Text(
                        r.studentName[0],
                        style: TextStyle(color: c, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.studentName,
                        style: const TextStyle(
                          color: MxCTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${pct.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: c,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET RÉGLAGES
// ═══════════════════════════════════════════════════════════════

class _SettingsTab extends StatelessWidget {
  final VoidCallback? onGoToEditor;
  final VoidCallback? onGoToValidations;
  const _SettingsTab({this.onGoToEditor, this.onGoToValidations});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<PlatformProvider>().currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Réglages',
              style: TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            // Profil prof
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MxCTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: MxCTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: MxCTheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user?.initials ?? '?',
                        style: const TextStyle(
                          color: MxCTheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: const TextStyle(
                          color: MxCTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Formateur · MxC Formations',
                        style: TextStyle(
                          color: MxCTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Plateforme',
              style: TextStyle(
                color: MxCTheme.textMuted,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.edit_note_outlined,
              label: 'Éditeur de questions',
              subtitle: 'Modifier les challenges et les réponses',
              onTap: () => onGoToEditor?.call(),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              context,
              icon: Icons.download_outlined,
              label: 'Exporter les résultats',
              subtitle: 'Télécharger CSV de toutes les sessions',
              onTap: () => _showComingSoon(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.read<PlatformProvider>().logout(),
                icon: const Icon(Icons.logout, color: MxCTheme.error),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: MxCTheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: MxCTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: MxCTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: MxCTheme.border),
      ),
      leading: Icon(icon, color: MxCTheme.primary, size: 20),
      title: Text(
        label,
        style:
            const TextStyle(color: MxCTheme.textPrimary, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style:
            const TextStyle(color: MxCTheme.textMuted, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: MxCTheme.textMuted,
        size: 18,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.construction, color: Colors.orange),
            SizedBox(width: 8),
            Text('Fonctionnalité à venir dans la prochaine version'),
          ],
        ),
        backgroundColor: MxCTheme.surfaceCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET ÉDITEUR DE QUESTIONS
// ═══════════════════════════════════════════════════════════════

class _EditorTab extends StatefulWidget {
  const _EditorTab();

  @override
  State<_EditorTab> createState() => _EditorTabState();
}

class _EditorTabState extends State<_EditorTab> {
  int _selectedDay = 1;
  Challenge? _selectedChallenge;

  List<Challenge> get _dayChallenges =>
      ChallengesData.challengesForDay(_selectedDay);

  @override
  void initState() {
    super.initState();
    _loadOverrides();
  }

  Future<void> _loadOverrides() async {
    // Appliquer les overrides persistés sur tous les challenges
    await EditorPersistenceService.applyOverrides(
      ChallengesData.allChallenges,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _selectedChallenge == null
          ? _buildChallengeList()
          : _buildChallengeEditor(_selectedChallenge!),
    );
  }

  // ─── Liste des challenges ───
  Widget _buildChallengeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Éditeur de questions',
                      style: TextStyle(
                        color: MxCTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sélectionnez un challenge à modifier',
                      style: TextStyle(
                        color: MxCTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sélecteur de jour
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [1, 2, 3].map((day) {
              final isSelected = _selectedDay == day;
              final dayLabels = {
                1: 'Jour 1',
                2: 'Jour 2',
                3: 'Jour 3',
              };
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MxCTheme.primary
                          : MxCTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? MxCTheme.primary
                            : MxCTheme.border,
                      ),
                    ),
                    child: Text(
                      dayLabels[day]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : MxCTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Liste des challenges du jour
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _dayChallenges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final challenge = _dayChallenges[i];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedChallenge = challenge),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MxCTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: challenge.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: challenge.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            challenge.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'C${challenge.orderInDay} — ${challenge.title}',
                              style: const TextStyle(
                                color: MxCTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${challenge.scenario.acts.length} actes · ${challenge.scenario.acts.fold(0, (sum, a) => sum + a.options.length)} options',
                              style: const TextStyle(
                                color: MxCTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.edit_outlined,
                        color: challenge.color,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Éditeur d'un challenge ───
  Widget _buildChallengeEditor(Challenge challenge) {
    return Column(
      children: [
        // Header avec retour
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: const BoxDecoration(
            color: MxCTheme.surface,
            border: Border(bottom: BorderSide(color: MxCTheme.border)),
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () =>
                    setState(() => _selectedChallenge = null),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                ),
                child: const Text(
                  '<',
                  style: TextStyle(
                    color: MxCTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: TextStyle(
                        color: challenge.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${challenge.scenario.acts.length} actes',
                      style: const TextStyle(
                        color: MxCTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Liste des actes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenge.scenario.acts.length,
            itemBuilder: (ctx, actIdx) {
              final act = challenge.scenario.acts[actIdx];
              return _ActEditorCard(
                challenge: challenge,
                act: act,
                actIndex: actIdx,
                onSaved: () => setState(() {}),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Carte éditeur d'un acte ───
class _ActEditorCard extends StatefulWidget {
  final Challenge challenge;
  final CrisisAct act;
  final int actIndex;
  final VoidCallback onSaved;

  const _ActEditorCard({
    required this.challenge,
    required this.act,
    required this.actIndex,
    required this.onSaved,
  });

  @override
  State<_ActEditorCard> createState() => _ActEditorCardState();
}

class _ActEditorCardState extends State<_ActEditorCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.challenge.color.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          // Header acte
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.challenge.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.actIndex + 1}',
                        style: TextStyle(
                          color: widget.challenge.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.act.title,
                      style: const TextStyle(
                        color: MxCTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    _expanded ? '▲' : '▼',
                    style: const TextStyle(
                      color: MxCTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenu expansible
          if (_expanded) ...[
            const Divider(color: MxCTheme.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tâche outil
                  _buildSectionLabel('Tâche à réaliser'),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1F2D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF00FF88)
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      widget.act.toolTask,
                      style: const TextStyle(
                        color: Color(0xFF00FF88),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () =>
                          _editToolTask(context),
                      icon: const Icon(Icons.edit,
                          size: 14, color: MxCTheme.primary),
                      label: const Text('Modifier',
                          style: TextStyle(
                              color: MxCTheme.primary, fontSize: 12)),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Options de décision
                  _buildSectionLabel(
                      '${widget.act.options.length} options de décision'),
                  const SizedBox(height: 8),
                  ...widget.act.options
                      .asMap()
                      .entries
                      .map((e) => _buildOptionRow(context, e.value, e.key)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: MxCTheme.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildOptionRow(
      BuildContext context, DecisionOption option, int index) {
    final labels = ['A', 'B', 'C', 'D'];
    final letter =
        index < labels.length ? labels[index] : '${index + 1}';
    final color = option.isCorrect
        ? const Color(0xFF00FF88)
        : const Color(0xFFFF4D6D);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  option.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _editOption(context, option, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MxCTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Éditer',
                    style: TextStyle(
                      color: MxCTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (option.isCorrect) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const SizedBox(width: 32),
                Icon(Icons.check_circle,
                    size: 12, color: color),
                const SizedBox(width: 4),
                const Text(
                  'Réponse correcte',
                  style: TextStyle(
                    color: Color(0xFF00FF88),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _editToolTask(BuildContext context) {
    // Lire l'acte frais dans le cache (pas widget.act qui peut être obsolète)
    final currentAct = widget.challenge.scenario.acts[widget.actIndex];
    final controller =
        TextEditingController(text: currentAct.toolTask);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: MxCTheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Modifier la tâche',
                style: TextStyle(
                  color: MxCTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentAct.title,
                style: const TextStyle(
                    color: MxCTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Décrivez la tâche à réaliser…',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: MxCTheme.surfaceCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: MxCTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: MxCTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: MxCTheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: MxCTheme.border),
                      ),
                      child: const Text('Annuler',
                          style: TextStyle(
                              color: MxCTheme.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Lire l'acte frais depuis le cache avant modification
                        final freshAct = widget.challenge.scenario.acts[widget.actIndex];
                        final newAct = freshAct.copyWith(
                          toolTask: controller.text.trim(),
                        );
                        final acts = widget.challenge.scenario.acts;
                        acts[widget.actIndex] = newAct;
                        // Persister la modification
                        EditorPersistenceService.saveToolTask(
                          challengeId: widget.challenge.id,
                          actIndex: widget.actIndex,
                          toolTask: controller.text.trim(),
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Tâche mise à jour'),
                            backgroundColor:
                                const Color(0xFF00BCD4),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10)),
                          ),
                        );
                        widget.onSaved();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MxCTheme.primary,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editOption(
      BuildContext context, DecisionOption option, int index) {
    // Lire l'option fraîche depuis le cache pour éviter les données périmées
    final currentAct2 = widget.challenge.scenario.acts[widget.actIndex];
    final freshOption = currentAct2.options.length > index
        ? currentAct2.options[index]
        : option;
    final labelCtrl = TextEditingController(text: freshOption.label);
    final explCtrl = TextEditingController(text: freshOption.explanation);
    final conseqCtrl = TextEditingController(text: freshOption.consequence);
    bool isCorrect = freshOption.isCorrect;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setDlgState) => Dialog(
          backgroundColor: MxCTheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Option ${['A', 'B', 'C', 'D'][index]}',
                            style: const TextStyle(
                              color: MxCTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.act.title,
                            style: const TextStyle(
                                color: MxCTheme.textMuted,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _dlgLabel('Libellé de l\'option'),
                const SizedBox(height: 6),
                _dlgField(labelCtrl, 'Texte de l\'option de décision…', 3),

                const SizedBox(height: 12),
                _dlgLabel('Explication (après sélection)'),
                const SizedBox(height: 6),
                _dlgField(explCtrl, 'Pourquoi cette réponse est-elle correcte/incorrecte ?', 2),

                const SizedBox(height: 12),
                _dlgLabel('Conséquence narrative'),
                const SizedBox(height: 6),
                _dlgField(conseqCtrl, 'Ce qui se passe si on choisit cette option…', 2),

                const SizedBox(height: 16),

                // Toggle bonne réponse
                GestureDetector(
                  onTap: () => setDlgState(() => isCorrect = !isCorrect),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? const Color(0xFF00FF88).withValues(alpha: 0.1)
                          : const Color(0xFFFF4D6D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCorrect
                            ? const Color(0xFF00FF88)
                            : const Color(0xFFFF4D6D),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: isCorrect
                              ? const Color(0xFF00FF88)
                              : const Color(0xFFFF4D6D),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isCorrect
                                ? 'Réponse correcte (bonne décision)'
                                : 'Réponse incorrecte (mauvaise décision)',
                            style: TextStyle(
                              color: isCorrect
                                  ? const Color(0xFF00FF88)
                                  : const Color(0xFFFF4D6D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Toucher pour changer',
                          style: TextStyle(
                            color: MxCTheme.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: MxCTheme.border),
                        ),
                        child: const Text('Annuler',
                            style: TextStyle(
                                color: MxCTheme.textSecondary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Lire l'acte et les options fraîches depuis le cache
                          final freshAct2 = widget.challenge.scenario.acts[widget.actIndex];
                          final newOption = freshOption.copyWith(
                            label: labelCtrl.text.trim(),
                            explanation: explCtrl.text.trim(),
                            consequence: conseqCtrl.text.trim(),
                            isCorrect: isCorrect,
                          );
                          final acts = widget.challenge.scenario.acts;
                          final newOptions = List<DecisionOption>.from(
                              freshAct2.options);
                          newOptions[index] = newOption;
                          acts[widget.actIndex] =
                              freshAct2.copyWith(options: newOptions);
                          // Persister la modification
                          EditorPersistenceService.saveOption(
                            challengeId: widget.challenge.id,
                            actIndex: widget.actIndex,
                            optionId: freshOption.id,
                            label: labelCtrl.text.trim(),
                            explanation: explCtrl.text.trim(),
                            consequence: conseqCtrl.text.trim(),
                            isCorrect: isCorrect,
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Option mise à jour'),
                              backgroundColor:
                                  const Color(0xFF00BCD4),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                          );
                          widget.onSaved();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MxCTheme.primary,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dlgLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: MxCTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _dlgField(
      TextEditingController ctrl, String hint, int maxLines) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
        filled: true,
        fillColor: MxCTheme.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MxCTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MxCTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MxCTheme.primary),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET VALIDATIONS — Correction des exercices par le formateur
// ═══════════════════════════════════════════════════════════════

class _ValidationsTab extends StatefulWidget {
  const _ValidationsTab();

  @override
  State<_ValidationsTab> createState() => _ValidationsTabState();
}

class _ValidationsTabState extends State<_ValidationsTab> {
  final _mgr = SubmissionManager.instance;

  @override
  void initState() {
    super.initState();
    _mgr.addListener(_refresh);
  }

  @override
  void dispose() {
    _mgr.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final submissions = _mgr.all.toList().reversed.toList();
    final pendingCount = submissions.where((s) => s.status == SubmissionStatus.pending).length;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Validations',
                          style: TextStyle(
                              color: MxCTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('Exercices soumis par les apprenants',
                          style: TextStyle(
                              color: MxCTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                if (pendingCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFFF9800).withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '$pendingCount en attente',
                      style: const TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Liste ─────────────────────────────────────────────
          Expanded(
            child: submissions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: submissions.length,
                    itemBuilder: (ctx, i) =>
                        _SubmissionCard(submission: submissions[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined,
                size: 56, color: MxCTheme.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('Aucune soumission pour l\'instant',
                style: TextStyle(color: MxCTheme.textMuted, fontSize: 14)),
            const SizedBox(height: 8),
            const Text(
                'Les exercices envoyés par les apprenants\napparaîtront ici.',
                textAlign: TextAlign.center,
                style: TextStyle(color: MxCTheme.textMuted, fontSize: 12)),
          ],
        ),
      );
}

// ── Carte d'une soumission ────────────────────────────────────────

class _SubmissionCard extends StatefulWidget {
  final TaskSubmission submission;
  const _SubmissionCard({required this.submission});

  @override
  State<_SubmissionCard> createState() => _SubmissionCardState();
}

class _SubmissionCardState extends State<_SubmissionCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.submission.status) {
      case SubmissionStatus.pending:   return const Color(0xFFFF9800);
      case SubmissionStatus.validated: return const Color(0xFF4CAF50);
      case SubmissionStatus.rejected:  return const Color(0xFFE53935);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.submission;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // ── Résumé (toujours visible) ──
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Icône mode
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        s.mode == PlayMode.team ? '👥' : '👤',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.authorName,
                            style: const TextStyle(
                                color: MxCTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('Jour ${s.dayNumber} · ${s.challengeTitle}',
                            style: const TextStyle(
                                color: MxCTheme.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                  // Badge statut
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(s.statusLabel,
                        style: TextStyle(
                            color: _statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: MxCTheme.textMuted, size: 20),
                ],
              ),
            ),
          ),

          // ── Détail dépliable ──
          if (_expanded) ...[
            Divider(height: 1, color: MxCTheme.border.withValues(alpha: 0.5)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Énoncé
                  _sectionLabel('📋 Exercice'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MxCTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(s.toolTask,
                        style: const TextStyle(
                            color: MxCTheme.textSecondary,
                            fontSize: 12,
                            height: 1.4)),
                  ),
                  const SizedBox(height: 12),

                  // Réponse
                  _sectionLabel('✍️ Réponse de l\'apprenant'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MxCTheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: MxCTheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(s.responseText,
                        style: const TextStyle(
                            color: MxCTheme.textPrimary,
                            fontSize: 13,
                            height: 1.5)),
                  ),
                  const SizedBox(height: 16),

                  // Bouton validation (si en attente)
                  if (s.status == SubmissionStatus.pending)
                    _ValidationActions(submission: s)
                  else
                    _ValidationResult(submission: s),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
          color: MxCTheme.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5));
}

// ── Formulaire de notation (si statut = pending) ──────────────────

class _ValidationActions extends StatefulWidget {
  final TaskSubmission submission;
  const _ValidationActions({required this.submission});

  @override
  State<_ValidationActions> createState() => _ValidationActionsState();
}

class _ValidationActionsState extends State<_ValidationActions> {
  double _score = 10;
  bool _bonus = false;
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    // Cherche la session correspondante dans SubmissionManager
    // (en mode démo on passe null → les pts s'ajoutent à 0)
    SubmissionManager.instance.validate(
      submissionId: widget.submission.id,
      score: _score.round(),
      bonus: _bonus,
      comment: _commentCtrl.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${widget.submission.authorName} — '
            '+${_score.round() + (_bonus ? 5 : 0)} pts crédités !',
          ),
          backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.95),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _reject() {
    if (_commentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ajoutez un commentaire avant de renvoyer.')),
      );
      return;
    }
    SubmissionManager.instance
        .reject(submissionId: widget.submission.id, comment: _commentCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final total = _score.round() + (_bonus ? 5 : 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Score ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Score exercice',
                style: TextStyle(
                    color: MxCTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: MxCTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${_score.round()} / 20 pts',
                  style: const TextStyle(
                      color: MxCTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: MxCTheme.primary,
            thumbColor: MxCTheme.primary,
            inactiveTrackColor: MxCTheme.border,
            overlayColor: MxCTheme.primary.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: _score,
            min: 0,
            max: 20,
            divisions: 20,
            onChanged: (v) => setState(() => _score = v),
          ),
        ),

        // ── Bonus ──
        InkWell(
          onTap: () => setState(() => _bonus = !_bonus),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _bonus
                  ? const Color(0xFFFFB800).withValues(alpha: 0.12)
                  : MxCTheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: _bonus
                      ? const Color(0xFFFFB800).withValues(alpha: 0.5)
                      : MxCTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  _bonus ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: const Color(0xFFFFB800),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Bonus qualité +5 pts',
                      style: TextStyle(
                          color: MxCTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
                Text(
                  _bonus ? '+5 pts' : '0 pt',
                  style: TextStyle(
                      color: _bonus
                          ? const Color(0xFFFFB800)
                          : MxCTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ── Total ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: MxCTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total à créditer',
                  style: TextStyle(
                      color: MxCTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              Text('+$total pts',
                  style: const TextStyle(
                      color: MxCTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Commentaire ──
        Container(
          decoration: BoxDecoration(
            color: MxCTheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MxCTheme.border),
          ),
          child: TextField(
            controller: _commentCtrl,
            maxLines: 3,
            style: const TextStyle(color: MxCTheme.textPrimary, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Commentaire pour l\'apprenant (optionnel)…',
              hintStyle:
                  TextStyle(color: MxCTheme.textMuted, fontSize: 12),
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Boutons d'action ──
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _reject,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('À revoir'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53935),
                  side: const BorderSide(color: Color(0xFFE53935)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _validate,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: Text('Valider +$total pts'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Résultat déjà traité ──────────────────────────────────────────

class _ValidationResult extends StatelessWidget {
  final TaskSubmission submission;
  const _ValidationResult({required this.submission});

  @override
  Widget build(BuildContext context) {
    final isValidated = submission.status == SubmissionStatus.validated;
    final color = isValidated ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isValidated ? Icons.verified_rounded : Icons.replay_rounded,
            color: color, size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isValidated
                      ? '✅ Validé — +${submission.totalCoachPoints} pts crédités'
                      : '🔄 Renvoyé pour révision',
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                if (submission.coachComment.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(submission.coachComment,
                      style: const TextStyle(
                          color: MxCTheme.textSecondary,
                          fontSize: 11,
                          height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PANNEAU PROGRESSIONS APPRENANTS (côté admin)
// Permet au formateur de voir les sauvegardes et mettre fin aux parties
// ═══════════════════════════════════════════════════════════════

class _ProgressionsPanel extends StatefulWidget {
  const _ProgressionsPanel();

  @override
  State<_ProgressionsPanel> createState() => _ProgressionsPanelState();
}

class _ProgressionsPanelState extends State<_ProgressionsPanel> {
  List<GameSaveData> _saves = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saves = await GameSaveService.instance.listAll();
    if (mounted) setState(() { _saves = saves; _loading = false; });
  }

  Future<void> _endGame(GameSaveData save) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MxCTheme.surface,
        title: const Text('Terminer la partie ?',
            style: TextStyle(color: MxCTheme.textPrimary)),
        content: Text(
          'Partie de ${save.authorName} (${save.gameId.toUpperCase()}) sera clôturée.\n'
          'Le joueur ne pourra plus jouer mais verra sa progression.',
          style: const TextStyle(color: MxCTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler',
                style: TextStyle(color: MxCTheme.primary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Terminer',
                style: TextStyle(color: Color(0xFFFF4D6D))),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await GameSaveService.instance
          .markFinished(save.gameId, save.authorName);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final active   = _saves.where((s) => !s.gameFinished).toList();
    final finished = _saves.where((s) => s.gameFinished).toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── En-tête ──────────────────────────────────────────
          const Text('Progressions apprenants',
              style: TextStyle(
                  color: MxCTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Parties en cours et terminées',
              style: TextStyle(color: MxCTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),

          if (_saves.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MxCTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Aucune progression sauvegardée',
                    style: TextStyle(color: MxCTheme.textMuted)),
              ),
            ),

          // ── Parties actives ───────────────────────────────────
          if (active.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('En cours',
                  style: TextStyle(
                      color: Color(0xFF00FF88),
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
            ...active.map((s) => _buildSaveCard(s, canEnd: true)),
            const SizedBox(height: 16),
          ],

          // ── Parties terminées ─────────────────────────────────
          if (finished.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Terminées',
                  style: TextStyle(
                      color: MxCTheme.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
            ...finished.map((s) => _buildSaveCard(s, canEnd: false)),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveCard(GameSaveData save, {required bool canEnd}) {
    final completed = save.challengeStatuses.values
        .where((v) => v == 'completed').length;
    final total = save.challengeStatuses.length;
    final gameColor = save.gameId == 'numerix'
        ? const Color(0xFF00BCD4)
        : const Color(0xFF9C27B0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canEnd
              ? gameColor.withValues(alpha: 0.3)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          // Pastille jeu
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: gameColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                save.gameId == 'numerix' ? 'N' : 'C',
                style: TextStyle(
                    color: gameColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(save.authorName,
                    style: const TextStyle(
                        color: MxCTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  '${save.gameId.toUpperCase()} · '
                  '${total > 0 ? "$completed/$total challenges" : "pas encore commencé"} · '
                  '${save.totalPoints} pts',
                  style: const TextStyle(
                      color: MxCTheme.textMuted, fontSize: 11),
                ),
                Text(
                  'Sauvegardé : ${_fmt(save.savedAt)}',
                  style: const TextStyle(
                      color: MxCTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          // Action
          if (canEnd)
            TextButton(
              onPressed: () => _endGame(save),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFF4D6D)),
              child: const Text('Terminer', style: TextStyle(fontSize: 12)),
            )
          else
            const Text('Terminée',
                style: TextStyle(color: MxCTheme.textMuted, fontSize: 11)),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
