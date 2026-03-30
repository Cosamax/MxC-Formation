import 'package:flutter/material.dart';
import 'models/clarity_models.dart';
import 'data/clarity_challenges_data.dart';
import 'screens/clarity_challenge_screen.dart';
import '../../platform/services/editor_persistence_service.dart';
import '../../platform/services/game_save_service.dart';

// ═══════════════════════════════════════════════════════════════
// CLARITY ZONE — Hub principal du jeu
// Business game sur la gestion des consignes professionnelles
// Basé sur les 20 fiches "Consignes" — MxC Formations
// ═══════════════════════════════════════════════════════════════

class ClarityGameHub extends StatefulWidget {
  const ClarityGameHub({super.key});

  @override
  State<ClarityGameHub> createState() => _ClarityGameHubState();
}

class _ClarityGameHubState extends State<ClarityGameHub>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // État de la session
  ClarityPlayMode? _selectedMode;
  int _currentStep = 0; // 0=accueil, 1=mode, 2=rôle (team), 3=carte challenges

  // Identité joueur / équipe
  String _authorName = 'Apprenant';
  ClarityGameSession? _gameSession;

  // Équipe
  final List<ClarityRole> _teamRoles = ClarityData.roles;
  String? _selectedRoleId;

  // Liste des challenges
  late List<ClarityChallenge> _challenges;

  // Champ de saisie du nom
  final TextEditingController _nameController = TextEditingController();

  static const String _gameId = 'clarity';

  // Séances expansées (accordion) — toutes ouvertes par défaut
  final Map<int, bool> _dayExpanded = {1: true, 2: true, 3: true};

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
    // Utiliser directement le cache partagé (pas de copie superficielle)
    _challenges = ClarityData.allChallenges;
    EditorPersistenceService.applyOverrides(_challenges).then((_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  /// Sauvegarde les statuts des challenges dans GameSaveService
  void _saveHubProgress({String? authorName}) {
    final name = authorName ?? _authorName;
    if (name.isEmpty || name == 'Apprenant') return;
    final statuses = <String, String>{};
    final scores   = <String, int>{};
    for (final c in _challenges) {
      statuses[c.id] = c.status.name;
      if (c.score != null) scores[c.id] = c.score!;
    }
    GameSaveService.instance.save(GameSaveData(
      gameId: _gameId,
      authorName: name,
      playMode: (_selectedMode ?? ClarityPlayMode.solo).name,
      roleId: _selectedRoleId,
      challengeStatuses: statuses,
      challengeScores: scores,
      savedAt: DateTime.now(),
    ));
  }

  /// Restaure les statuts des challenges depuis une sauvegarde
  Future<void> _restoreHubProgress(String name) async {
    final save = await GameSaveService.instance.load(_gameId, name);
    if (save == null || save.gameFinished) return;
    if (!mounted) return;
    setState(() {
      for (final c in _challenges) {
        final s = save.challengeStatuses[c.id];
        if (s != null) {
          c.status = ClarityChallengeStatus.values.firstWhere(
              (v) => v.name == s,
              orElse: () => c.status);
        }
        final sc = save.challengeScores[c.id];
        if (sc != null) c.score = sc;
      }
      if (save.roleId != null) _selectedRoleId = save.roleId;
      _selectedMode = save.playMode == 'team'
          ? ClarityPlayMode.team
          : ClarityPlayMode.solo;
      _currentStep = 3;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Progression restaurée — reprise là où vous étiez'),
          backgroundColor: const Color(0xFF9C27B0).withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Dialogue de fin de partie
  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B27),
        title: const Text('Terminer la partie ?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Toute votre progression sera conservée.\nVous pourrez la consulter mais plus jouer.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFF9C27B0))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await GameSaveService.instance
                  .markFinished(_gameId, _authorName);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Terminer',
                style: TextStyle(color: Color(0xFFFF4D6D))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
        leading: TextButton(
          child: const Text('<', style: TextStyle(color: Colors.white70, fontSize: 18)),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'ZONE CLARTÉ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_currentStep == 3)
            TextButton(
              onPressed: _showEndGameDialog,
              child: const Text(
                'Terminer',
                style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 13),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildWelcome();
      case 1:
        return _buildModeSelection();
      case 2:
        return _buildRoleSelection();
      case 3:
        return _buildChallengeMap();
      default:
        return _buildWelcome();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 0 — ACCUEIL
  // ═══════════════════════════════════════════════════════════════

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Header cabinet
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4527A0), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CLARTÉ CONSEIL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Cabinet de conseil en organisation',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'CLARTÉ CONSEIL est un cabinet de conseil en organisation de 80 collaborateurs. '
                  'La direction a identifié un problème clé : les consignes floues coûtent '
                  '3 semaines de productivité par an à l\'organisation. '
                  'Votre mission : maîtriser l\'art de donner et recevoir des consignes claires.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Objectif : Passer de 40% à 90% de consignes comprises du premier coup.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Indicateurs de départ
          _buildIndicators(),

          const SizedBox(height: 24),

          // Parcours
          _buildSectionTitle('Votre parcours en 3 séances'),
          const SizedBox(height: 12),
          ...[1, 2, 3].map((day) => _buildDayPreviewCard(day)),

          const SizedBox(height: 24),

          // Méthodes utilisées
          _buildSectionTitle('Méthodes & outils pédagogiques'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ClarityData.tools.map((t) => _buildToolChip(t)).toList(),
          ),

          const SizedBox(height: 32),

          // Champ nom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF161B27),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF7B1FA2).withValues(alpha: 0.4)),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Votre prénom ou nom d\'équipe (optionnel)',
                hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bouton démarrer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  setState(() => _authorName = name);
                  // Tenter de restaurer une sauvegarde
                  _restoreHubProgress(name).then((_) {
                    if (_currentStep == 0 && mounted) {
                      _gameSession = ClarityGameSession(
                        sessionId: 'clarity_${DateTime.now().millisecondsSinceEpoch}',
                        mode: ClarityPlayMode.solo,
                        authorName: _authorName,
                        formatorCode: 'PROF',
                      );
                      _fadeCtrl.reset();
                      setState(() => _currentStep = 1);
                      _fadeCtrl.forward();
                    }
                  });
                } else {
                  _gameSession = ClarityGameSession(
                    sessionId:
                        'clarity_${DateTime.now().millisecondsSinceEpoch}',
                    mode: ClarityPlayMode.solo,
                    authorName: _authorName,
                    formatorCode: 'PROF',
                  );
                  _fadeCtrl.reset();
                  setState(() => _currentStep = 1);
                  _fadeCtrl.forward();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Rejoindre CLARTÉ CONSEIL',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      children: [
        _buildIndicatorBadge('Clarté', '40/100', Colors.blue),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Confiance', '60/100', Colors.green),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Efficacité', '55/100', Colors.orange),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Stress', '40/100', Colors.red),
      ],
    );
  }

  Widget _buildIndicatorBadge(
      String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 9),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDayPreviewCard(int day) {
    final count = ClarityData.challengesForDay(day).length;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B27),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: ClarityData.dayColor(day).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Séance $day — ${ClarityData.dayTitle(day)}',
                  style: TextStyle(
                    color: ClarityData.dayColor(day),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$count challenges • ${ClarityData.dayDescription(day)}',
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 11, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF7B1FA2).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF7B1FA2).withValues(alpha: 0.3)),
      ),
      child: Text(name,
          style: const TextStyle(
              color: Color(0xFFCE93D8), fontSize: 11)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold));
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 1 — SÉLECTION DU MODE
  // ═══════════════════════════════════════════════════════════════

  Widget _buildModeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Comment souhaitez-vous jouer ?',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Les challenges sont identiques — seule la dynamique change.',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 32),
          _buildModeCard(
            mode: ClarityPlayMode.solo,
            title: 'Solo',
            subtitle: 'Formation individuelle',
            description:
                'Progressez à votre rythme. Toutes les décisions sont les vôtres. '
                'Idéal pour l\'auto-formation ou la préparation à une prise de poste.',
            emoji: '',
            pros: ['Rythme libre', 'Réflexion individuelle', 'Progression mesurée'],
          ),
          const SizedBox(height: 16),
          _buildModeCard(
            mode: ClarityPlayMode.team,
            title: 'Équipe',
            subtitle: 'Co-apprentissage collaboratif',
            description:
                'Chaque membre joue un rôle différent. Les débats enrichissent '
                'les décisions. Idéal en formation présentielle ou distancielle.',
            emoji: '',
            pros: ['Débats enrichissants', 'Perspectives multiples', 'Cohésion d\'équipe'],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required ClarityPlayMode mode,
    required String title,
    required String subtitle,
    required String description,
    required String emoji,
    required List<String> pros,
  }) {
    final isSelected = _selectedMode == mode;
    final accent = const Color(0xFF7B1FA2);

    return GestureDetector(
      onTap: () async {
        setState(() => _selectedMode = mode);
        await Future.delayed(const Duration(milliseconds: 300));
        _fadeCtrl.reset();
        if (mode == ClarityPlayMode.team) {
          setState(() => _currentStep = 2);
        } else {
          _gameSession = ClarityGameSession(
            sessionId: 'clarity_${DateTime.now().millisecondsSinceEpoch}',
            mode: mode,
            authorName: _authorName,
            formatorCode: 'PROF',
          );
          setState(() => _currentStep = 3);
        }
        _fadeCtrl.forward();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.15)
              : const Color(0xFF161B27),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? accent
                : accent.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: TextStyle(
                            color: accent,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.4)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: pros
                  .map((p) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(p,
                            style: TextStyle(
                                color: accent,
                                fontSize: 11)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 2 — SÉLECTION DU RÔLE (mode équipe)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildRoleSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Choisissez votre rôle',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'En mode équipe, chaque rôle apporte une perspective unique sur les consignes.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 24),
          ..._teamRoles.map((role) => _buildRoleCard(role)),
          const SizedBox(height: 24),
          if (_selectedRoleId != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _gameSession = ClarityGameSession(
                    sessionId:
                        'clarity_${DateTime.now().millisecondsSinceEpoch}',
                    mode: ClarityPlayMode.team,
                    authorName: _authorName,
                    formatorCode: 'PROF',
                    selectedRoleId: _selectedRoleId,
                  );
                  _fadeCtrl.reset();
                  setState(() => _currentStep = 3);
                  _fadeCtrl.forward();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirmer ce rôle',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRoleCard(ClarityRole role) {
    final isSelected = _selectedRoleId == role.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedRoleId = role.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? role.color.withValues(alpha: 0.15)
              : const Color(0xFF161B27),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? role.color : role.color.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: role.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Center(child: Text(role.emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(role.description,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(role.responsibilities,
                      style: TextStyle(
                          color: role.color, fontSize: 11, height: 1.3)),
                ],
              ),
            ),
            if (isSelected)
              Text('', style: TextStyle(color: role.color, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 3 — CARTE DES CHALLENGES
  // ═══════════════════════════════════════════════════════════════

  Widget _buildChallengeMap() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildProgressBar(),
          const SizedBox(height: 24),
          ...[1, 2, 3].map((day) => _buildDaySection(day)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final completed = _challenges
        .where((c) => c.status == ClarityChallengeStatus.completed)
        .length;
    final total = _challenges.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B27),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF7B1FA2).withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progression CLARTÉ CONSEIL',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text('$completed / $total challenges',
                  style: const TextStyle(
                      color: Color(0xFF9C27B0), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF0D1117),
              color: const Color(0xFF7B1FA2),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(int day) {
    final dayChallenges =
        _challenges.where((c) => c.dayNumber == day).toList()
          ..sort((a, b) => a.orderInDay.compareTo(b.orderInDay));

    final completedCount = dayChallenges
        .where((c) => c.status == ClarityChallengeStatus.completed)
        .length;
    final isExpanded = _dayExpanded[day] ?? true;
    final dayColor = ClarityData.dayColor(day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── En-tête cliquable de la séance ────────────────────────
        GestureDetector(
          onTap: () => setState(() => _dayExpanded[day] = !isExpanded),
          child: Container(
            margin: EdgeInsets.only(bottom: isExpanded ? 10 : 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: dayColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dayColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Text(ClarityData.dayEmoji(day),
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Séance $day — ${ClarityData.dayTitle(day)}',
                        style: TextStyle(
                            color: dayColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$completedCount/${dayChallenges.length} challenges terminés',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                // Badge d'état
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: completedCount == dayChallenges.length
                        ? const Color(0xFF00E676).withValues(alpha: 0.15)
                        : dayColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completedCount == dayChallenges.length ? '✓ Terminé' : '▶ En cours',
                    style: TextStyle(
                        color: completedCount == dayChallenges.length
                            ? const Color(0xFF00E676)
                            : dayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Text('▼',
                      style: TextStyle(color: dayColor, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
        // ── Contenu pliable ───────────────────────────────────────
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              ...dayChallenges.map((c) => _buildChallengeCard(c)),
              const SizedBox(height: 8),
            ],
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 250),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChallengeCard(ClarityChallenge challenge) {
    final isCompleted = challenge.status == ClarityChallengeStatus.completed;
    final isLocked = !challenge.isEnabled;

    Color statusColor;
    String statusEmoji;

    if (isLocked) {
      statusColor = Colors.white30;
      statusEmoji = 'Verrouillé';
    } else if (isCompleted) {
      statusColor = const Color(0xFF00E676);
      statusEmoji = 'Terminé';
    } else {
      statusColor = challenge.color;
      statusEmoji = 'Disponible';
    }

    return GestureDetector(
      onTap: isLocked ? null : () => _startChallenge(challenge),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLocked ? 0.4 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B27),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF00E676).withValues(alpha: 0.3)
                  : challenge.color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.subtitle,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (challenge.score != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Score : ${challenge.score}/100',
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(statusEmoji, style: TextStyle(color: statusColor, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  void _startChallenge(ClarityChallenge challenge) async {
    // Calculer la position du challenge dans sa séance
    final dayChalls = _challenges
        .where((c) => c.dayNumber == challenge.dayNumber)
        .toList()
      ..sort((a, b) => a.orderInDay.compareTo(b.orderInDay));
    final idx   = dayChalls.indexOf(challenge) + 1;
    final total = dayChalls.length;

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ClarityChallengeScreen(
          challenge: challenge,
          mode: _selectedMode ?? ClarityPlayMode.solo,
          selectedRoleId: _selectedRoleId,
          session: _gameSession,
          authorName: _authorName,
          challengeIndex: idx,
          challengeTotal: total,
        ),
      ),
    );

    if (result != null && result['completed'] == true) {
      setState(() {
        final idx = _challenges.indexWhere((c) => c.id == challenge.id);
        if (idx != -1) {
          _challenges[idx].status = ClarityChallengeStatus.completed;
          _challenges[idx].score = result['score'] as int?;
          // Déverrouiller le challenge suivant dans la même journée
          final next = _challenges.firstWhere(
            (c) =>
                c.dayNumber == challenge.dayNumber &&
                c.orderInDay == challenge.orderInDay + 1,
            orElse: () => challenge,
          );
          if (next != challenge &&
              next.status == ClarityChallengeStatus.locked) {
            next.status = ClarityChallengeStatus.available;
          }
        }
      });
      // Sauvegarder la progression hub après chaque challenge terminé
      _saveHubProgress();
    }
  }
}
