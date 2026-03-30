import 'package:flutter/material.dart';
import '../../../platform/models/platform_theme.dart';
import '../../../platform/models/platform_models.dart';
import '../../../platform/data/games_data.dart';
import '../auth/auth_screen.dart';

// ═══════════════════════════════════════════════════════════════
// LANDING PAGE — Façade publique MxC Formations
// ═══════════════════════════════════════════════════════════════

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _catalogKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _slideCtrl, curve: Curves.easeOut));
    _fadeCtrl.forward();
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToAuth({bool register = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AuthScreen(initialRegister: register)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHero(),
                _buildValueProps(),
                Container(key: _catalogKey, child: _buildCatalogPreview()),
                _buildHowItWorks(),
                _buildCTA(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── HERO ───────────────────────────────────────────────────

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0E1A), Color(0xFF0D1630)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: MxCTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school,
                        color: Colors.black, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MxC Formations',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _goToAuth(),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                      color: Color(0xFF00D4FF), fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 56),

          // Accroche
          ShaderMask(
            shaderCallback: (bounds) =>
                MxCTheme.primaryGradient.createShader(bounds),
            child: const Text(
              'Apprenez en\nvivant la situation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Des serious games immersifs pour former vos\n'
            'apprenants en situation professionnelle réelle.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 36),

          // CTAs
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _goToAuth(register: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _scrollToCatalog(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Voir les jeux',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Badges de confiance
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _trustBadge('🎓', 'Situation pro réelle'),
              _trustBadge('👥', 'Solo & équipe'),
              _trustBadge('🛠️', 'Outils gratuits intégrés'),
              _trustBadge('📊', 'Débrief pédagogique'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trustBadge(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // ─── VALEUR AJOUTÉE ──────────────────────────────────────────

  Widget _buildValueProps() {
    final props = [
      (
        Icons.business_center,
        const Color(0xFF00D4FF),
        'Immersion totale',
        'L\'apprenant a un rôle dans une entreprise fictive et prend des décisions qui ont des conséquences réelles.'
      ),
      (
        Icons.people_alt,
        const Color(0xFF00FF88),
        'Mode équipe',
        'Chaque apprenant a un rôle complémentaire. Les décisions se prennent collectivement sous pression.'
      ),
      (
        Icons.build_outlined,
        const Color(0xFFFFB800),
        'Outils du terrain',
        'Les apprenants utilisent les vrais outils gratuits : Canva, CNIL.fr, Brevo, Google Analytics…'
      ),
      (
        Icons.tune,
        const Color(0xFFFF6B35),
        'Contrôle formateur',
        'Activez ou désactivez chaque challenge. Donnez l\'accès à qui vous voulez, quand vous voulez.'
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      color: const Color(0xFF0D1322),
      child: Column(
        children: [
          _sectionTitle('Pourquoi MxC Formations ?'),
          const SizedBox(height: 24),
          ...props.map((p) => _valuePropCard(
              p.$1, p.$2, p.$3, p.$4)),
        ],
      ),
    );
  }

  Widget _valuePropCard(
      IconData icon, Color color, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── APERÇU CATALOGUE ────────────────────────────────────────

  Widget _buildCatalogPreview() {
    final games = GamesData.catalog;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      color: const Color(0xFF0A0E1A),
      child: Column(
        children: [
          _sectionTitle('Les jeux disponibles'),
          const SizedBox(height: 8),
          const Text(
            'Connectez-vous pour accéder aux jeux.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ...games.map((g) => _catalogCard(g)),
        ],
      ),
    );
  }

  Widget _catalogCard(game) {
    final isAvailable = game.status == GameStatus.published;
    return GestureDetector(
      onTap: () => _goToAuth(register: true),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isAvailable
                ? game.color.withValues(alpha: 0.35)
                : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: game.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(game.icon, color: game.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(game.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      if (!isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Bientôt',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(game.subtitle,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            // Prix
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? game.color.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isAvailable
                          ? game.color.withValues(alpha: 0.35)
                          : Colors.white12,
                    ),
                  ),
                  child: Text(
                    game.displayPrice,
                    style: TextStyle(
                      color: isAvailable ? game.color : Colors.white38,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAvailable ? 'par apprenant' : 'à venir',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── COMMENT ÇA MARCHE ───────────────────────────────────────

  Widget _buildHowItWorks() {
    final steps = [
      ('1', const Color(0xFF00D4FF), 'Inscrivez-vous',
          'Créez votre compte apprenant en 30 secondes.'),
      ('2', const Color(0xFF00FF88), 'Accédez au jeu',
          'Achetez l\'accès ou recevez-le de votre formateur.'),
      ('3', const Color(0xFFFFB800), 'Jouez & apprenez',
          'Solo ou en équipe, prenez des décisions réelles.'),
      ('4', const Color(0xFFFF6B35), 'Débriefez',
          'Analysez vos décisions et progressez.'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      color: const Color(0xFF0D1322),
      child: Column(
        children: [
          _sectionTitle('Comment ça marche ?'),
          const SizedBox(height: 24),
          ...steps.map((s) => _stepCard(s.$1, s.$2, s.$3, s.$4)),
        ],
      ),
    );
  }

  Widget _stepCard(
      String num, Color color, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Text(num,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(desc,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CTA FINAL ───────────────────────────────────────────────

  Widget _buildCTA() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0076FF), Color(0xFF00BCD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Prêt à apprendre\nautrement ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rejoignez MxC Formations et vivez la formation\ncomme jamais auparavant.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
                height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _goToAuth(register: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0076FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Créer mon compte gratuitement',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => _goToAuth(),
            child: Text(
              'J\'ai déjà un compte',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FOOTER ──────────────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: MxCTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.school,
                    color: Colors.black, size: 16),
              ),
              const SizedBox(width: 8),
              const Text('MxC Formations',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '© 2025 MxC Formations — Tous droits réservés',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
  }

  void _scrollToCatalog() {
    final ctx = _catalogKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        400,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }
}
