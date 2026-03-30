import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/platform_provider.dart';
import '../../models/platform_theme.dart';
import '../../models/platform_models.dart';
import '../../data/games_data.dart';
import '../../../games/droit_internet/nexova_game.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MxCTheme.background,
      bottomNavigationBar: _buildBottomNav(),
      body: IndexedStack(
        index: _selectedTab,
        children: const [
          _CatalogTab(),
          _ProgressTab(),
          _ProfileTab(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Jeux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progression',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET CATALOGUE
// ═══════════════════════════════════════════════════════════════

class _CatalogTab extends StatelessWidget {
  const _CatalogTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlatformProvider>();
    final user = provider.currentUser;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, user)),
          SliverToBoxAdapter(child: _buildFeaturedGame(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Tous les jeux',
                    style: TextStyle(
                      color: MxCTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: MxCTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${GamesData.catalog.length}',
                      style: const TextStyle(
                        color: MxCTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final game = GamesData.catalog[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _GameCard(game: game),
                );
              },
              childCount: GamesData.catalog.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PlatformUser? user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${user?.name.split(' ').first ?? ''}  👋',
                  style: const TextStyle(
                    color: MxCTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'Prêt à apprendre ?',
                  style: TextStyle(
                    color: MxCTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          // Avatar
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: user?.color ?? MxCTheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user?.initials ?? '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedGame(BuildContext context) {
    final featured = GamesData.published.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => _launchGame(context, featured),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                featured.color.withValues(alpha: 0.8),
                featured.color.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: featured.color.withValues(alpha: 0.5),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  featured.icon,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '⭐ Jeu Vedette',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      featured.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      featured.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTag(
                            featured.id == 'nexova'
                                ? '${featured.totalQuestions} challenges'
                                : '${featured.totalQuestions} questions',
                            Icons.quiz_outlined),
                        const SizedBox(width: 8),
                        _buildTag(
                            featured.id == 'nexova'
                                ? '~${featured.estimatedMinutes ~/ 60}h au total'
                                : '~${featured.estimatedMinutes} min',
                            Icons.timer_outlined),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Jouer',
                            style: TextStyle(
                              color: featured.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _launchGame(BuildContext context, GameInfo game) {
    if (game.status == GameStatus.draft) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.construction, color: Colors.orange),
              const SizedBox(width: 8),
              Text('${game.title} — Bientôt disponible !'),
            ],
          ),
          backgroundColor: MxCTheme.surfaceCard,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    // Router selon l'id du jeu
    switch (game.id) {
      case 'nexova':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NexovaGameHub()),
        );
        break;
      default:
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

// ═══════════════════════════════════════════════════════════════
// CARTE JEU
// ═══════════════════════════════════════════════════════════════

class _GameCard extends StatelessWidget {
  final GameInfo game;
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final isAvailable = game.status == GameStatus.published;

    return GestureDetector(
      onTap: () {
        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${game.title} — Bientôt disponible !'),
              backgroundColor: MxCTheme.surfaceCard,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          return;
        }
        // Router selon l'id du jeu
        switch (game.id) {
          case 'nexova':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NexovaGameHub()),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${game.title} — Bientôt disponible !'),
                backgroundColor: MxCTheme.surfaceCard,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
        }
      },
      child: Container(
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
        child: Row(
          children: [
            // Icône
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: game.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(game.icon, color: game.color, size: 26),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          game.title,
                          style: TextStyle(
                            color: isAvailable
                                ? MxCTheme.textPrimary
                                : MxCTheme.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (!isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: MxCTheme.accentWarm.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Bientôt',
                            style: TextStyle(
                              color: MxCTheme.accentWarm,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    game.subtitle,
                    style: const TextStyle(
                      color: MxCTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _miniTag(
                        game.id == 'nexova'
                            ? '${game.totalQuestions} challenges'
                            : '${game.totalQuestions}Q',
                        game.color,
                      ),
                      const SizedBox(width: 6),
                      _miniTag(
                        game.id == 'nexova'
                            ? '~${game.estimatedMinutes ~/ 60}h'
                            : '${game.estimatedMinutes}min',
                        MxCTheme.textMuted,
                      ),
                      const SizedBox(width: 6),
                      _miniTag(game.difficulty, MxCTheme.textMuted),
                    ],
                  ),
                ],
              ),
            ),
            if (isAvailable) ...[
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: game.color),
            ],
          ],
        ),
      ),
    );
  }

  Widget _miniTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET PROGRESSION
// ═══════════════════════════════════════════════════════════════

class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

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
              'Ma Progression',
              style: TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            _buildXPCard(user),
            const SizedBox(height: 20),
            const Text(
              'Mes Badges',
              style: TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _buildBadgesGrid(),
            const SizedBox(height: 20),
            const Text(
              'Compétences acquises',
              style: TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _buildSkillsProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildXPCard(PlatformUser? user) {
    final pts = user?.totalPoints ?? 0;
    final level = (pts / 500).floor() + 1;
    final progress = (pts % 500) / 500;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: MxCTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Niveau',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$level',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$pts XP',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${(level * 500)} XP',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.black.withValues(alpha: 0.2),
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.black),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${user?.gamesPlayed ?? 0} parties jouées',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid() {
    final badges = BadgesData.all;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: badges.length,
      itemBuilder: (_, i) => _BadgeCard(badge: badges[i], earned: i == 0),
    );
  }

  Widget _buildSkillsProgress() {
    final skills = [
      {'name': 'Droit Internet', 'value': 0.72, 'color': MxCTheme.law},
      {'name': 'RGPD', 'value': 0.45, 'color': MxCTheme.gdpr},
      {'name': 'Contrats', 'value': 0.60, 'color': MxCTheme.contract},
      {'name': 'E-commerce', 'value': 0.38, 'color': MxCTheme.marketing},
    ];

    return Column(
      children: skills.map((s) {
        final value = s['value'] as double;
        final color = s['color'] as Color;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s['name'] as String,
                    style: const TextStyle(
                      color: MxCTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${(value * 100).toInt()}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: MxCTheme.surfaceCard,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final GameBadge badge;
  final bool earned;
  const _BadgeCard({required this.badge, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MxCTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned
              ? badge.color.withValues(alpha: 0.5)
              : MxCTheme.border,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: earned
                  ? badge.color.withValues(alpha: 0.15)
                  : MxCTheme.border.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              badge.icon,
              color: earned ? badge.color : MxCTheme.textMuted,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: earned ? MxCTheme.textPrimary : MxCTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!earned)
            const Text(
              'Non obtenu',
              style: TextStyle(color: MxCTheme.textMuted, fontSize: 9),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ONGLET PROFIL
// ═══════════════════════════════════════════════════════════════

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<PlatformProvider>().currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: user?.color ?? MxCTheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (user?.color ?? MxCTheme.primary)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.initials ?? '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? '',
              style: const TextStyle(
                color: MxCTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Apprenant MxC Formations',
              style: TextStyle(color: MxCTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            _buildStatsRow(user),
            const SizedBox(height: 24),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(PlatformUser? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem('${user?.totalPoints ?? 0}', 'Points XP', MxCTheme.primary),
        _statItem('${user?.gamesPlayed ?? 0}', 'Parties', MxCTheme.accent),
        _statItem('${user?.badges.length ?? 0}', 'Badges', MxCTheme.accentWarm),
      ],
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: MxCTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _menuItem(
          icon: Icons.history,
          label: 'Historique des parties',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _menuItem(
          icon: Icons.emoji_events,
          label: 'Classement général',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _menuItem(
          icon: Icons.info_outline,
          label: 'À propos de MxC Formations',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.read<PlatformProvider>().logout(),
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
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
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
        style: const TextStyle(color: MxCTheme.textPrimary, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: MxCTheme.textMuted,
        size: 18,
      ),
    );
  }
}
