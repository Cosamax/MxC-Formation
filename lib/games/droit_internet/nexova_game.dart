import 'package:flutter/material.dart';
import 'models/game_models.dart';
import 'data/challenges_data.dart';
import 'screens/challenge_screen.dart';
import '../../platform/services/editor_persistence_service.dart';
import '../../platform/services/game_save_service.dart';

// ═══════════════════════════════════════════════════════════════
// NUMÉRIX GAME HUB — Point d'entrée principal du jeu
// ═══════════════════════════════════════════════════════════════

class NexovaGameHub extends StatefulWidget {
  const NexovaGameHub({super.key});

  @override
  State<NexovaGameHub> createState() => _NexovaGameHubState();
}

class _NexovaGameHubState extends State<NexovaGameHub>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // État de la session
  PlayMode? _selectedMode;
  int _currentStep = 0; // 0=accueil, 1=mode, 2=rôle (team), 3=carte challenges

  // Identité joueur / équipe
  String _authorName = 'Apprenant';
  DroitGameSession? _gameSession;

  // Équipe
  final List<TeamRole> _teamRoles = ChallengesData.roles;
  String? _selectedRoleId;

  // Liste des challenges avec activation
  late List<Challenge> _challenges;

  // Champ de saisie du nom sur la page d'accueil
  final TextEditingController _nameController = TextEditingController();

  static const String _gameId = 'numerix';

  // Séances expansées (accordion) — toutes ouvertes par défaut
  final Map<int, bool> _dayExpanded = {1: true, 2: true, 3: true};

  @override
  void initState() {
    super.initState();
    _fadeCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
    _challenges = ChallengesData.allChallenges;
    EditorPersistenceService.applyOverrides(_challenges).then((_) {
      if (mounted) setState(() {});
    });
    _gameSession = DroitGameSession(
      sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      mode: PlayMode.solo,
      company: PlayerCompany(
        name: 'NUMÉRIX',
        logoEmoji: '',
        logoColor: '#00BCD4',
        sector: 'Tech',
        tagline: '',
      ),
      roles: const [],
      formatorCode: 'PROF',
    );
    // Vérifier s'il existe une sauvegarde à restaurer
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkResume());
  }

  /// Vérifie s'il existe une sauvegarde non terminée pour cet apprenant
  Future<void> _checkResume() async {
    // On ne peut vérifier que si on a déjà un nom d'auteur
    // Le nom est saisi à l'étape 0 — on tentera la restauration
    // après saisie du nom dans _buildWelcomeStep()
  }

  /// Sauvegarde les statuts actuels des challenges dans GameSaveService
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
      playMode: (_selectedMode ?? PlayMode.solo).name,
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
          c.status = ChallengeStatus.values.firstWhere(
              (v) => v.name == s,
              orElse: () => c.status);
        }
        final sc = save.challengeScores[c.id];
        if (sc != null) c.score = sc;
      }
      if (save.playMode == 'team') {
        _selectedMode = PlayMode.team;
      } else {
        _selectedMode = PlayMode.solo;
      }
      if (save.roleId != null) _selectedRoleId = save.roleId;
      // Aller directement à la carte des challenges
      _currentStep = 3;
    });
    // Afficher un message de reprise
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Progression restaurée — reprise là où vous étiez'),
          backgroundColor: const Color(0xFF00BCD4).withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
          child: const Text('<', style: TextStyle(color: Colors.white70, fontSize: 18)),
        ),
        title: _buildAppBarTitle(),
        centerTitle: true,
        actions: [
          // Bouton "Terminer la partie" — visible uniquement sur la carte
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

  Widget _buildAppBarTitle() {
    return const Text(
      'NUMÉRIX',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: 2,
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
  // ÉTAPE 0 — PAGE D'ACCUEIL
  // ═══════════════════════════════════════════════════════════════

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Header entreprise
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0076FF), Color(0xFF00BCD4)],
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
                            'NUMÉRIX',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Scale-up • Mobilier de bureau connecté',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'NUMÉRIX est une scale-up française en pleine croissance : 45 employés, 8 M€ de CA, récemment levée à 2 M€. Elle vend du mobilier de bureau connecté en B2B et B2C, en France et en Belgique.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D6D).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFF4D6D).withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Croissance rapide = Failles juridiques. '
                          'Vous devez remettre NUMÉRIX en conformité avant l\'audit DGCCRF.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
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

          // Ce qui vous attend
          _buildSectionTitle('Ce qui vous attend'),
          const SizedBox(height: 12),
          ...[
            ('Séance 1', '5 challenges • Fondamentaux légaux', '~1h chacun'),
            ('Séance 2', '5 challenges • Tempête commerciale', '~1h chacun'),
            ('Séance 3', '5 challenges • Réputation & Audit final', '~1h chacun'),
          ].map((d) => _buildDayCard(d.$1, d.$2, d.$3)),

          const SizedBox(height: 24),

          // Outils intégrés
          _buildSectionTitle('Outils gratuits intégrés'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Canva', 'INPI.fr', 'CNIL.fr', 'Brevo',
              'Google Analytics', 'HubSpot CRM', 'Cookiebot', 'Trustpilot'
            ].map((t) => _buildToolChip(t)).toList(),
          ),

          const SizedBox(height: 32),

          // Champ nom / prénom ou équipe
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF151B2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Votre nom ou nom d\'équipe (optionnel)',
                hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                border: InputBorder.none,
                prefixIcon: null,
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
                  _gameSession!.roles.clear();
                  // Tenter de restaurer une sauvegarde pour ce joueur
                  _restoreHubProgress(name).then((_) {
                    // Si aucune sauvegarde, poursuivre le flux normal
                    if (_currentStep == 0 && mounted) {
                      _fadeCtrl.reset();
                      setState(() => _currentStep = 1);
                      _fadeCtrl.forward();
                    }
                  });
                } else {
                  _fadeCtrl.reset();
                  setState(() => _currentStep = 1);
                  _fadeCtrl.forward();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Rejoindre NUMÉRIX',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        _buildIndicatorBadge('Réputation', '75/100', Colors.green),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Conformité', '40/100', Colors.orange),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Finances', '70/100', Colors.blue),
        const SizedBox(width: 8),
        _buildIndicatorBadge('Risque', '60/100', Colors.red),
      ],
    );
  }

  Widget _buildIndicatorBadge(
      String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            
            Text(
              value,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(String day, String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00BCD4).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$day — $title',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                Text(duration,
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildToolChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
      ),
      child: Text(name,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
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
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez votre mode de jeu. Le formateur peut changer ce paramètre à tout moment.',
            style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),

          // Mode Solo
          _buildModeCard(
            mode: PlayMode.solo,
            title: 'Mode Solo',
            description:
                'Vous incarnez le CEO de NUMÉRIX. Vous prenez toutes les décisions seul et en assumez les conséquences.',
            pros: ['Autonomie totale', 'Rythme personnel', 'Idéal en auto-formation'],
            color: const Color(0xFF00BCD4),
          ),

          const SizedBox(height: 16),

          // Mode Équipe
          _buildModeCard(
            mode: PlayMode.team,
            title: 'Mode Équipe',
            description:
                'Chaque apprenant a un rôle distinct. Certaines décisions nécessitent un consensus. Chaque erreur d\'un membre impacte tout le groupe.',
            pros: ['5 rôles complémentaires', 'Décisions collectives', 'Dynamique de groupe'],
            color: const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required PlayMode mode,
    required String title,
    required String description,
    required List<String> pros,
    required Color color,
  }) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedMode = mode);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mode == PlayMode.team) {
            _fadeCtrl.reset();
            setState(() => _currentStep = 2);
            _fadeCtrl.forward();
          } else {
            _fadeCtrl.reset();
            setState(() => _currentStep = 3);
            _fadeCtrl.forward();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : const Color(0xFF151B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSelected)
                  Text('OK', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(description,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14, height: 1.5)),
            const SizedBox(height: 12),
            ...pros.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text('•', style: TextStyle(color: color, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(p,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 2 — SÉLECTION DU RÔLE (mode équipe uniquement)
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
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Chaque rôle a des responsabilités spécifiques. '
            'Certaines décisions nécessiteront l\'accord de plusieurs membres.',
            style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          ..._teamRoles.map((role) => _buildRoleCard(role)),
          const SizedBox(height: 16),
          if (_selectedRoleId != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _fadeCtrl.reset();
                  setState(() => _currentStep = 3);
                  _fadeCtrl.forward();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Confirmer mon rôle',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(TeamRole role) {
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
              : const Color(0xFF151B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? role.color : role.color.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(role.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: TextStyle(
                        color: role.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(role.description,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: role.responsibilities
                        .map((r) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: role.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(r,
                                  style: TextStyle(
                                      color: role.color, fontSize: 11)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Text('OK', style: TextStyle(color: role.color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉTAPE 3 — CARTE DES CHALLENGES
  // ═══════════════════════════════════════════════════════════════

  Widget _buildChallengeMap() {
    final days = [1, 2, 3];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Barre de progression
          _buildProgressBar(),

          const SizedBox(height: 24),

          // Challenges par jour
          ...days.map((day) => _buildDaySection(day)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final completed =
        _challenges.where((c) => c.status == ChallengeStatus.completed).length;
    final total = _challenges.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progression NUMÉRIX',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('$completed / $total challenges',
                  style: const TextStyle(
                      color: Color(0xFF00BCD4), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF0A0E1A),
              color: const Color(0xFF00BCD4),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(int day) {
    final dayChallenges = _challenges
        .where((c) => c.dayNumber == day)
        .toList()
      ..sort((a, b) => a.orderInDay.compareTo(b.orderInDay));

    final dayNames = {
      1: 'Séance 1 — Fondamentaux',
      2: 'Séance 2 — Tempête commerciale',
      3: 'Séance 3 — Réputation & Audit',
    };

    final completedCount = dayChallenges
        .where((c) => c.status == ChallengeStatus.completed)
        .length;
    final isExpanded = _dayExpanded[day] ?? true;
    final dayColor = const Color(0xFF00BCD4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── En-tête cliquable de la séance ────────────────────────
        GestureDetector(
          onTap: () => setState(() => _dayExpanded[day] = !isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            margin: EdgeInsets.only(bottom: isExpanded ? 10.0 : 16.0),
            decoration: BoxDecoration(
              color: dayColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dayColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayNames[day] ?? 'Séance $day',
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
                // Indicateur de progression compact
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: completedCount == dayChallenges.length
                        ? const Color(0xFF00FF88).withValues(alpha: 0.15)
                        : dayColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completedCount == dayChallenges.length ? '✓ Terminé' : '▶ En cours',
                    style: TextStyle(
                        color: completedCount == dayChallenges.length
                            ? const Color(0xFF00FF88)
                            : dayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                // Flèche d'expansion
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
        // ── Contenu expansible ────────────────────────────────────
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

  Widget _buildChallengeCard(Challenge challenge) {
    final isCompleted = challenge.status == ChallengeStatus.completed;
    final isEnabled = challenge.isEnabled;
    final isLocked = !isEnabled;

    Color statusColor;
    String statusEmoji;

    if (isLocked) {
      statusColor = Colors.white30;
      statusEmoji = 'verrouillé';
    } else if (isCompleted) {
      statusColor = const Color(0xFF00FF88);
      statusEmoji = 'terminé';
    } else {
      statusColor = challenge.color;
      statusEmoji = '>';
    }

    return GestureDetector(
      onTap: isLocked
          ? null
          : () => _startChallenge(challenge),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLocked ? 0.4 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151B2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF00FF88).withValues(alpha: 0.4)
                  : challenge.color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: challenge.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'C${challenge.orderInDay}',
                            style: TextStyle(
                                color: challenge.color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            challenge.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.subtitle,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          challenge.toolName,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                        if (challenge.score != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            '${challenge.score}/100',
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Statut
              Text(statusEmoji, style: TextStyle(color: statusColor, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  void _startChallenge(Challenge challenge) async {
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
        builder: (_) => ChallengeScreen(
          challenge: challenge,
          mode: _selectedMode ?? PlayMode.solo,
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
          _challenges[idx].status = ChallengeStatus.completed;
          _challenges[idx].score = result['score'] as int?;
          // Débloquer le suivant
          final next = _challenges.firstWhere(
            (c) =>
                c.dayNumber == challenge.dayNumber &&
                c.orderInDay == challenge.orderInDay + 1,
            orElse: () => challenge,
          );
          if (next != challenge) {
            next.status = ChallengeStatus.available;
          }
        }
      });
      // Sauvegarder la progression hub après chaque challenge terminé
      _saveHubProgress();
    }
  }

  /// Affiche le dialogue de fin de partie (joueur)
  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF151B2E),
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
                style: TextStyle(color: Color(0xFF00BCD4))),
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
}
