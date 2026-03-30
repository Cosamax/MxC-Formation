import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/platform_provider.dart';
import '../../models/platform_models.dart';
import '../../models/platform_theme.dart';
import '../../services/stripe_service.dart';
import '../../../games/droit_internet/nexova_game.dart';

// ═══════════════════════════════════════════════════════════════
// CATALOGUE APPRENANT — Jeux disponibles avec tarifs & accès
// ═══════════════════════════════════════════════════════════════

class GameCatalogScreen extends StatefulWidget {
  const GameCatalogScreen({super.key});

  @override
  State<GameCatalogScreen> createState() => _GameCatalogScreenState();
}

class _GameCatalogScreenState extends State<GameCatalogScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  String _filterDomain = 'all';

  final Map<String, String> _domainLabels = {
    'all': 'Tous',
    'droit': 'Droit',
    'gdpr': 'RGPD',
    'startup': 'Startup',
    'marketing': 'Marketing',
    'finance': 'Finance',
    'rh': 'RH',
  };

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildHeader(),
            _buildDomainFilter(),
            Expanded(child: _buildGameList()),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final provider = context.read<PlatformProvider>();
    return AppBar(
      backgroundColor: const Color(0xFF0D1322),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: Colors.white54, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: MxCTheme.primaryGradient,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.school, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 8),
          const Text('MxC Formations',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        // Avatar utilisateur
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => _showProfileMenu(context, provider),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: provider.currentUser?.color ??
                  const Color(0xFF00D4FF),
              child: Text(
                provider.currentUser?.initials ?? '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileMenu(BuildContext ctx, PlatformProvider provider) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF0D1322),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: provider.currentUser?.color ??
                      const Color(0xFF00D4FF),
                  child: Text(
                    provider.currentUser?.initials ?? '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.currentUser?.name ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        provider.currentUser?.email ?? '',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white12),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout,
                  color: Color(0xFFFF4D6D), size: 20),
              title: const Text('Se déconnecter',
                  style: TextStyle(
                      color: Color(0xFFFF4D6D), fontSize: 14)),
              onTap: () {
                Navigator.pop(ctx);
                provider.logout();
                Navigator.of(ctx).popUntil((r) => r.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────

  Widget _buildHeader() {
    return Consumer<PlatformProvider>(
      builder: (ctx, provider, _) {
        final name = provider.currentUser?.name ?? '';
        final firstName = name.split(' ').first;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          color: const Color(0xFF0D1322),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, $firstName 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choisissez un jeu pour commencer votre formation.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── FILTRE DOMAINE ──────────────────────────────────────────

  Widget _buildDomainFilter() {
    return Container(
      height: 44,
      color: const Color(0xFF0D1322),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: _domainLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final key = _domainLabels.keys.elementAt(i);
          final label = _domainLabels[key]!;
          final isActive = _filterDomain == key;
          return GestureDetector(
            onTap: () => setState(() => _filterDomain = key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                gradient: isActive ? MxCTheme.primaryGradient : null,
                color: isActive ? null : const Color(0xFF151B2E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : Colors.white12,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white60,
                  fontSize: 12,
                  fontWeight: isActive
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── LISTE DES JEUX ──────────────────────────────────────────

  Widget _buildGameList() {
    return Consumer<PlatformProvider>(
      builder: (ctx, provider, _) {
        final games = provider.allGames.where((g) {
          if (_filterDomain == 'all') return true;
          return g.domain == _filterDomain;
        }).toList();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => _GameCard(
            game: games[i],
            hasAccess: provider.currentUserHasAccess(games[i].id),
            onPurchase: () => _handlePurchase(ctx, provider, games[i]),
            onPlay: () => _handlePlay(ctx, games[i]),
          ),
        );
      },
    );
  }

  // ─── LOGIQUE ACHAT / ACCÈS ───────────────────────────────────

  Future<void> _handlePurchase(
    BuildContext ctx,
    PlatformProvider provider,
    GameInfo game,
  ) async {
    if (provider.currentUser == null) return;

    // Si tarif non défini, montrer infos
    if (game.pricingLabel == 'À définir') {
      _showPricingTBD(ctx, game);
      return;
    }

    // Si gratuit → accès direct
    if (game.isFree) {
      await provider.simulatePurchase(game.id);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Accès à ${game.title} activé !'),
            backgroundColor: const Color(0xFF00FF88),
          ),
        );
      }
      return;
    }

    // Sinon → dialog Stripe
    if (ctx.mounted) {
      await showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (_) => StripePaymentDialog(
          game: game,
          customerEmail: provider.currentUser!.email,
          onSuccess: () async {
            await provider.simulatePurchase(game.id);
          },
        ),
      );
    }
  }

  void _handlePlay(BuildContext ctx, GameInfo game) {
    if (game.id == 'nexova') {
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => const NexovaGameHub()),
      );
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('${game.title} — Bientôt disponible !'),
          backgroundColor: const Color(0xFF151B2E),
        ),
      );
    }
  }

  void _showPricingTBD(BuildContext ctx, GameInfo game) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF0D1322),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: game.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(game.icon, color: game.color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              game.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Le tarif de ce jeu est en cours de définition.\n'
              'Contactez votre formateur pour obtenir l\'accès.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white60, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white54,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CARTE JEU
// ═══════════════════════════════════════════════════════════════

class _GameCard extends StatelessWidget {
  final GameInfo game;
  final bool hasAccess;
  final VoidCallback onPurchase;
  final VoidCallback onPlay;

  const _GameCard({
    required this.game,
    required this.hasAccess,
    required this.onPurchase,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = game.status == GameStatus.published;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAccess
              ? game.color.withValues(alpha: 0.5)
              : isPublished
                  ? game.color.withValues(alpha: 0.2)
                  : Colors.white12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne 1 : icône + titre + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: game.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(game.icon, color: game.color, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (hasAccess)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FF88)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xFF00FF88)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Text('Accès actif',
                                  style: TextStyle(
                                    color: Color(0xFF00FF88),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )
                          else if (!isPublished)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Bientôt',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                  )),
                            ),
                        ],
                      ),
                      Text(game.subtitle,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description courte
            Text(
              game.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 12, height: 1.4),
            ),

            const SizedBox(height: 12),

            // Skills pills
            if (game.skills.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: game.skills.take(3).map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: game.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: game.color.withValues(alpha: 0.2)),
                    ),
                    child: Text(s,
                        style: TextStyle(
                            color: game.color.withValues(alpha: 0.9),
                            fontSize: 10)),
                  );
                }).toList(),
              ),

            const SizedBox(height: 14),

            // Ligne bas : durée + difficulté + prix + bouton
            Row(
              children: [
                // Durée
                _metaChip(Icons.schedule,
                    '${(game.estimatedMinutes / 60).round()}h'),
                const SizedBox(width: 8),
                // Difficulté
                _metaChip(Icons.signal_cellular_alt, game.difficulty),
                const Spacer(),
                // Prix ou bouton
                if (isPublished) _buildActionButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (hasAccess) {
      return ElevatedButton.icon(
        onPressed: onPlay,
        icon: const Icon(Icons.play_arrow, size: 16),
        label: const Text('Jouer',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: game.color,
          foregroundColor: Colors.black,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPurchase,
      icon: const Icon(Icons.shopping_cart_outlined, size: 16),
      label: Text(
        game.pricingLabel == 'À définir'
            ? 'Accéder'
            : game.displayPrice,
        style:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: game.color.withValues(alpha: 0.15),
        foregroundColor: game.color,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: game.color.withValues(alpha: 0.4)),
        ),
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _metaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white38),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}
