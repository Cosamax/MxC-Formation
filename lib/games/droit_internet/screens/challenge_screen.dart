import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../../../platform/services/game_save_service.dart';

// ═══════════════════════════════════════════════════════════════
// ÉCRAN DE CHALLENGE — Moteur de jeu immersif
// ═══════════════════════════════════════════════════════════════

class ChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  final PlayMode mode;
  final String? selectedRoleId;
  final DroitGameSession? session;   // session courante (pour scoring)
  final String authorName;           // nom apprenant ou équipe
  final int challengeIndex;          // ex : 2 (2ème challenge du jour)
  final int challengeTotal;          // ex : 5 (5 challenges au total pour ce jour)

  const ChallengeScreen({
    super.key,
    required this.challenge,
    required this.mode,
    this.selectedRoleId,
    this.session,
    this.authorName = 'Apprenant',
    this.challengeIndex = 1,
    this.challengeTotal = 1,
  });

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen>
    with TickerProviderStateMixin {
  int _currentActIndex = 0;
  String? _selectedOptionId;
  bool _showConsequence = false;
  bool _actCompleted = false;
  bool _challengeFinished = false;

  // Score dynamique
  int _reputation = 75;
  int _compliance = 40;
  int _finance = 70;
  int _legalRisk = 60;
  int _correctCount = 0;
  int _totalPoints = 0;          // points bruts cumulés
  int _lastPointsDelta = 0;      // +10 ou +0 pour l'animation
  bool _showPointsAnim = false;  // affiche le badge flottant
  final List<String> _decisions = [];

  // Options mélangées pour l'acte courant
  List<DecisionOption> _shuffledOptions = [];

  // ── toolTask : saisie et état de soumission ──────────────────
  final TextEditingController _taskController = TextEditingController();
  SubmissionStatus? _taskStatus;   // null = pas encore soumis
  int _coachPointsReceived = 0;    // points reçus après validation formateur

  // ── Sauvegarde ──────────────────────────────────────────────
  static const String _gameId = 'numerix';

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late AnimationController _pointsAnimCtrl;
  late Animation<double> _pointsAnim;

  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(
            begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _pointsAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pointsAnim = CurvedAnimation(
        parent: _pointsAnimCtrl, curve: Curves.easeOut);
    _pointsAnimCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showPointsAnim = false);
        _pointsAnimCtrl.reset();
      }
    });
    _slideCtrl.forward();

    if (widget.challenge.status == ChallengeStatus.locked) {
      widget.challenge.status = ChallengeStatus.available;
    }
    _shuffleOptions();

    // Enregistrer le listener dès le départ (pas seulement après soumission)
    SubmissionManager.instance.addListener(_onSubmissionUpdate);
    // Restaurer l'état d'une soumission précédente (après rechargement)
    _restoreSubmissionState();
    // Restaurer la sauvegarde de progression
    _loadSave();
  }

  /// Charge la sauvegarde de progression (acte, indicateurs, score)
  Future<void> _loadSave() async {
    final save = await GameSaveService.instance
        .load(_gameId, widget.authorName);
    if (save == null || save.gameFinished) return;
    if (save.activeChallengeId != widget.challenge.id) return;
    if (!mounted) return;
    setState(() {
      _currentActIndex  = save.actIndex.clamp(0, _actCount - 1);
      _selectedOptionId = save.selectedOptionId;
      _showConsequence  = save.showConsequence;
      _actCompleted     = save.actCompleted;
      _reputation       = save.reputation;
      _compliance       = save.compliance;
      _finance          = save.finance;
      _legalRisk        = save.legalRisk;
      _totalPoints      = save.totalPoints;
      _correctCount     = save.correctCount;
      _decisions.addAll(save.decisions);
    });
    _shuffleOptions();
  }

  /// Sauvegarde la progression courante
  void _autoSave() {
    // Statuts des challenges (pas d'accès direct ici — on sauvegarde juste l'acte)
    GameSaveService.instance.save(GameSaveData(
      gameId: _gameId,
      authorName: widget.authorName,
      playMode: widget.mode.name,
      challengeStatuses: {},    // mis à jour par le hub
      challengeScores: {},      // mis à jour par le hub
      activeChallengeId: widget.challenge.id,
      actIndex: _currentActIndex,
      selectedOptionId: _selectedOptionId,
      showConsequence: _showConsequence,
      actCompleted: _actCompleted,
      reputation: _reputation,
      compliance: _compliance,
      finance: _finance,
      legalRisk: _legalRisk,
      totalPoints: _totalPoints,
      correctCount: _correctCount,
      decisions: List<String>.from(_decisions),
      coachPointsReceived: _coachPointsReceived,
      savedAt: DateTime.now(),
    ));
  }

  /// Relit la soumission persistante pour restaurer le statut et les points
  void _restoreSubmissionState() {
    final sub = SubmissionManager.instance.all.lastWhere(
      (s) => s.challengeId == widget.challenge.id
          && s.authorName == widget.authorName,
      orElse: () => TaskSubmission(
        id: '', sessionId: '', challengeId: '',
        dayNumber: 0, challengeTitle: '', toolTask: '',
        responseText: '', authorName: '', mode: PlayMode.solo,
      ),
    );
    if (sub.id.isNotEmpty) {
      _taskStatus = sub.status;
      if (sub.status == SubmissionStatus.validated) {
        _coachPointsReceived = sub.totalCoachPoints;
        _totalPoints        += sub.totalCoachPoints;
      }
    }
  }

  void _shuffleOptions() {
    final act = _currentAct;
    if (act == null) return;
    _shuffledOptions = List<DecisionOption>.from(act.options)..shuffle(_rng);
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _pointsAnimCtrl.dispose();
    _taskController.dispose();
    SubmissionManager.instance.removeListener(_onSubmissionUpdate);
    super.dispose();
  }

  // Appelé quand le formateur valide/rejette — rafraîcht l'UI
  void _onSubmissionUpdate() {
    final sub = SubmissionManager.instance.all.lastWhere(
      (s) => s.challengeId == widget.challenge.id
          && s.authorName == widget.authorName,
      orElse: () => TaskSubmission(
        id: '', sessionId: '', challengeId: '',
        dayNumber: 0, challengeTitle: '', toolTask: '',
        responseText: '', authorName: '', mode: PlayMode.solo,
      ),
    );
    if (sub.id.isNotEmpty && mounted) {
      setState(() {
        _taskStatus = sub.status;
        if (sub.status == SubmissionStatus.validated) {
          final newPts = sub.totalCoachPoints;
          if (newPts > _coachPointsReceived) {
            _lastPointsDelta  = newPts - _coachPointsReceived;
            _totalPoints     += _lastPointsDelta;
            _showPointsAnim   = true;
            _pointsAnimCtrl.forward(from: 0);
          }
          _coachPointsReceived = newPts;
        }
      });
    }
  }

  void _submitTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    final act = _currentAct;
    if (act == null) return;

    final submission = TaskSubmission(
      id: '${widget.challenge.id}_${widget.authorName}_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: widget.session?.sessionId ?? 'local',
      challengeId: widget.challenge.id,
      dayNumber: widget.challenge.dayNumber,
      challengeTitle: widget.challenge.title,
      toolTask: act.toolTask,
      responseText: text,
      authorName: widget.authorName,
      mode: widget.mode,
    );
    SubmissionManager.instance.add(submission);
    setState(() => _taskStatus = SubmissionStatus.pending);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exercice envoyé au formateur !'),
        backgroundColor: const Color(0xFF00FF88).withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  CrisisAct? get _currentAct {
    final acts = widget.challenge.scenario.acts;
    if (_currentActIndex < acts.length) return acts[_currentActIndex];
    return null;
  }

  int get _actCount => widget.challenge.scenario.acts.length;

  // Score affiché en % basé sur les bonnes réponses
  int get _liveScore =>
      _actCount > 0 ? (_correctCount * 100 / _actCount).round() : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: _challengeFinished
            ? _buildDebriefScreen()
            : _buildChallengeBody(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CORPS PRINCIPAL
  // ═══════════════════════════════════════════════════════════════

  Widget _buildChallengeBody() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentActIndex == 0 && !_actCompleted)
                    _buildContextCard(),
                  const SizedBox(height: 16),
                  if (_currentAct != null) ...[
                    _buildActHeader(),
                    const SizedBox(height: 16),
                    _buildNarrative(),
                    if (_currentAct!.characterMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildCharacterMessage(),
                    ],
                    const SizedBox(height: 20),
                    _buildToolTask(),
                    const SizedBox(height: 20),
                    _buildDecisionOptions(),
                    if (_showConsequence && _selectedOptionId != null) ...[
                      const SizedBox(height: 20),
                      _buildConsequenceCard(),
                      const SizedBox(height: 20),
                      _buildNextButton(),
                    ],
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HEADER — avec score visible en permanence
  // ═══════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1322),
        border: Border(
            bottom: BorderSide(
                color: widget.challenge.color.withValues(alpha: 0.3))),
      ),
      child: Column(
        children: [
          // Ligne 1 : retour + titre + score
          Row(
            children: [
              GestureDetector(
                onTap: _confirmExit,
                child: const Text('X', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.challenge.title,
                      style: TextStyle(
                          color: widget.challenge.color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        // Indicateur challenge X/Y dans la journée
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: widget.challenge.color.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'C${widget.challengeIndex}/${widget.challengeTotal}',
                            style: TextStyle(
                              color: widget.challenge.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Indicateur acte
                        Text(
                          'Acte ${_currentActIndex + 1} / $_actCount',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ─── SCORE VISIBLE EN PERMANENCE ───
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00BCD4), Color(0xFF0076FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$_totalPoints pts',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14),
                            ),
                            Text(
                              '$_liveScore%',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ── Badge animation +10 / +0 ──
                  if (_showPointsAnim)
                    Positioned(
                      top: -22,
                      right: 0,
                      child: AnimatedBuilder(
                        animation: _pointsAnim,
                        builder: (_, __) => Opacity(
                          opacity: (1.0 - _pointsAnim.value).clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, -20 * _pointsAnim.value),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _lastPointsDelta > 0
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFE53935),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_lastPointsDelta > 0
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFFE53935))
                                        .withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Text(
                                _lastPointsDelta > 0
                                    ? '+$_lastPointsDelta pts'
                                    : '0 pt',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barre progression actes
          Row(
            children: List.generate(
              _actCount,
              (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i < _currentActIndex
                        ? const Color(0xFF00FF88)
                        : i == _currentActIndex
                            ? widget.challenge.color
                            : const Color(0xFF1A2035),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Indicateurs compacts
          _buildLiveIndicators(),
        ],
      ),
    );
  }

  Widget _buildLiveIndicators() {
    return Row(
      children: [
        _buildMiniIndicator(_reputation, Colors.green),
        const SizedBox(width: 6),
        _buildMiniIndicator(_compliance, Colors.orange),
        const SizedBox(width: 6),
        _buildMiniIndicator(_finance, Colors.blue),
        const SizedBox(width: 6),
        _buildMiniIndicator(100 - _legalRisk, Colors.red),
      ],
    );
  }

  Widget _buildMiniIndicator(int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white12,
              color: color,
              minHeight: 3,
            ),
          ),
          Text('$value',
              style: TextStyle(color: color, fontSize: 9)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CONTENU
  // ═══════════════════════════════════════════════════════════════

  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.challenge.color.withValues(alpha: 0.15),
            widget.challenge.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: widget.challenge.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.challenge.subtitle,
            style: TextStyle(
                color: widget.challenge.color,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.challenge.scenario.urgencyMessage,
              style: const TextStyle(
                  color: Color(0xFFFFB800),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.challenge.scenario.roleInstructions,
            style: const TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildActHeader() {
    final act = _currentAct!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: widget.challenge.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: widget.challenge.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                '${_currentActIndex + 1}',
                style: TextStyle(
                    color: widget.challenge.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              act.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrative() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1322),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _currentAct!.narrative,
        style: const TextStyle(
            color: Color(0xDEFFFFFF), fontSize: 14, height: 1.7),
      ),
    );
  }

  Widget _buildCharacterMessage() {
    final act = _currentAct!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Center(
              child: const Text('', style: TextStyle(fontSize: 0)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.characterName ?? 'Interlocuteur',
                  style: const TextStyle(
                      color: Color(0xFF00BCD4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  act.characterMessage!,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── TÂCHE OUTIL — simplifiée, avec badge validation coach ───
  Widget _buildToolTask() {
    final statusColor = _taskStatus == null
        ? const Color(0xFF00FF88)
        : _taskStatus == SubmissionStatus.pending
            ? const Color(0xFFFF9800)
            : _taskStatus == SubmissionStatus.validated
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE53935);

    final statusLabel = _taskStatus == null
        ? 'Validation coach'
        : _taskStatus == SubmissionStatus.pending
            ? 'En attente'
            : _taskStatus == SubmissionStatus.validated
                ? 'Validé +\$_coachPointsReceived pts'
                : 'À revoir';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1F2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ────────────────────────────────────────────
          Row(
            children: [
              const SizedBox.shrink(),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.challenge.toolName,
                  style: const TextStyle(
                      color: Color(0xFF00FF88),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Énoncé ─────────────────────────────────────────────
          Text(
            _currentAct!.toolTask,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 14),

          // ── Affichage selon statut ──────────────────────────────
          if (_taskStatus == SubmissionStatus.validated) ..._buildValidatedBanner(),
          if (_taskStatus == SubmissionStatus.rejected)  ..._buildRejectedBanner(),
          if (_taskStatus == SubmissionStatus.pending) ..._buildPendingBanner(),
          if (_taskStatus == null) ..._buildTaskInputArea(),
        ],
      ),
    );
  }

  List<Widget> _buildTaskInputArea() => [
    Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF00FF88).withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: _taskController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _taskStatus == null ? _submitTask() : null,
        decoration: const InputDecoration(
          hintText: 'Rédigez votre réponse ici…',
          hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          contentPadding: EdgeInsets.all(12),
          border: InputBorder.none,
        ),
      ),
    ),
    const SizedBox(height: 10),
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FF88),
          foregroundColor: const Color(0xFF0A0E1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        child: const Text('Envoyer au formateur'),
      ),
    ),
  ];

  List<Widget> _buildPendingBanner() => [
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9800).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Votre exercice est en cours de correction par le formateur.',
              style: TextStyle(color: Color(0xFFFF9800), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    ),
  ];

  List<Widget> _buildValidatedBanner() => [
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercice validé — +$_coachPointsReceived points !',
                  style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  SubmissionManager.instance.all
                      .lastWhere(
                        (s) => s.challengeId == widget.challenge.id
                            && s.authorName == widget.authorName,
                        orElse: () => TaskSubmission(
                          id: '', sessionId: '', challengeId: '',
                          dayNumber: 0, challengeTitle: '', toolTask: '',
                          responseText: '', authorName: '', mode: PlayMode.solo,
                        ),
                      )
                      .coachComment
                      .isNotEmpty
                    ? SubmissionManager.instance.all
                        .lastWhere(
                          (s) => s.challengeId == widget.challenge.id
                              && s.authorName == widget.authorName,
                        )
                        .coachComment
                    : 'Bon travail !',
                  style: const TextStyle(
                      color: Color(0xFFB0BEC5), fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ];

  List<Widget> _buildRejectedBanner() => [
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'À revoir — le formateur vous a laissé un retour :',
                  style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  SubmissionManager.instance.all
                      .lastWhere(
                        (s) => s.challengeId == widget.challenge.id
                            && s.authorName == widget.authorName,
                        orElse: () => TaskSubmission(
                          id: '', sessionId: '', challengeId: '',
                          dayNumber: 0, challengeTitle: '', toolTask: '',
                          responseText: '', authorName: '', mode: PlayMode.solo,
                        ),
                      )
                      .coachComment,
                  style: const TextStyle(
                      color: Color(0xFFB0BEC5), fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 10),
    // Permettre de re-soumettre
    ..._buildTaskInputArea(),
  ];

  // ─── DÉCISIONS — texte lisible + ordre aléatoire ───
  Widget _buildDecisionOptions() {
    if (_currentAct == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quelle est votre décision ?',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        if (widget.mode == PlayMode.team &&
            widget.selectedRoleId != null) ...[
          const SizedBox(height: 4),
          Text(
            'En tant que ${_getRoleName(widget.selectedRoleId!)}, votre avis est crucial.',
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: 12),
        ..._shuffledOptions
            .asMap()
            .entries
            .map((e) => _buildOptionCard(e.value, e.key)),
      ],
    );
  }

  Widget _buildOptionCard(DecisionOption option, int displayIndex) {
    final labels = ['A', 'B', 'C', 'D'];
    final letter = displayIndex < labels.length ? labels[displayIndex] : '?';

    final isSelected = _selectedOptionId == option.id;
    final hasSelected = _selectedOptionId != null;

    Color borderColor;
    Color bgColor;
    Color letterBg;
    Color letterColor;
    Widget? badge;

    if (!hasSelected) {
      borderColor = Colors.white24;
      bgColor = const Color(0xFF151B2E);
      letterBg = const Color(0xFF00BCD4).withValues(alpha: 0.15);
      letterColor = const Color(0xFF00BCD4);
    } else if (isSelected) {
      if (option.isCorrect) {
        borderColor = const Color(0xFF00FF88);
        bgColor = const Color(0xFF00FF88).withValues(alpha: 0.08);
        letterBg = const Color(0xFF00FF88).withValues(alpha: 0.2);
        letterColor = const Color(0xFF00FF88);
        badge = const Text('OK',
            style: TextStyle(color: Color(0xFF00FF88), fontSize: 12, fontWeight: FontWeight.bold));
      } else {
        borderColor = const Color(0xFFFF4D6D);
        bgColor = const Color(0xFFFF4D6D).withValues(alpha: 0.08);
        letterBg = const Color(0xFFFF4D6D).withValues(alpha: 0.2);
        letterColor = const Color(0xFFFF4D6D);
        badge = const Text('X',
            style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 18, fontWeight: FontWeight.bold));
      }
    } else if (_showConsequence && option.isCorrect) {
      borderColor = const Color(0xFF00FF88).withValues(alpha: 0.4);
      bgColor = const Color(0xFF00FF88).withValues(alpha: 0.04);
      letterBg = const Color(0xFF00FF88).withValues(alpha: 0.1);
      letterColor = const Color(0xFF00FF88);
      badge = const Text('OK',
          style: TextStyle(color: Color(0xFF00FF88), fontSize: 12, fontWeight: FontWeight.bold));
    } else {
      borderColor = Colors.white.withValues(alpha: 0.06);
      bgColor = const Color(0xFF0F1625);
      letterBg = Colors.white12;
      letterColor = Colors.white38;
    }

    return GestureDetector(
      onTap: hasSelected ? null : () => _selectOption(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lettre A / B / C
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: letterBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                      color: letterColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── TEXTE LISIBLE — fond sombre + texte blanc ───
                  Text(
                    option.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.45),
                  ),
                  if (_showConsequence && isSelected) ...[
                    const SizedBox(height: 8),
                    Text(
                      option.explanation,
                      style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              badge,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConsequenceCard() {
    if (_selectedOptionId == null || _currentAct == null) {
      return const SizedBox.shrink();
    }

    final selectedOption = _shuffledOptions.firstWhere(
      (o) => o.id == _selectedOptionId,
      orElse: () => _shuffledOptions.first,
    );

    final isCorrect = selectedOption.isCorrect;
    final color =
        isCorrect ? const Color(0xFF00FF88) : const Color(0xFFFF4D6D);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isCorrect ? 'OK' : 'X',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Bonne décision !' : 'Mauvaise décision…',
                style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            selectedOption.consequence,
            style: const TextStyle(
                color: Color(0xCCFFFFFF), fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 14),
          _buildEffectRow(selectedOption.effect),
        ],
      ),
    );
  }

  Widget _buildEffectRow(IndicatorEffect effect) {
    final effects = [
      ('Rep.', effect.reputation),
      ('Conf.', effect.compliance),
      ('Fin.', effect.finance),
      ('Risq.', -effect.legalRisk),
    ];

    return Wrap(
      spacing: 12,
      children: effects.map((e) {
        final value = e.$2;
        if (value == 0) return const SizedBox.shrink();
        final color =
            value > 0 ? const Color(0xFF00FF88) : const Color(0xFFFF4D6D);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(e.$1, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '${value > 0 ? '+' : ''}$value',
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNextButton() {
    final isLastAct = _currentActIndex >= _actCount - 1;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLastAct ? _finishChallenge : _nextAct,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLastAct ? const Color(0xFF00FF88) : const Color(0xFF00BCD4),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          isLastAct ? 'Voir le débrief' : 'Acte suivant ',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DÉBRIEF FINAL
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDebriefScreen() {
    final scenario = widget.challenge.scenario;
    final percentage = _actCount > 0
        ? (_correctCount * 100 / _actCount).round()
        : 0;
    final isGood = percentage >= 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Score final
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGood
                    ? const Color(0xFF00FF88).withValues(alpha: 0.15)
                    : const Color(0xFFFF4D6D).withValues(alpha: 0.15),
                border: Border.all(
                    color: isGood
                        ? const Color(0xFF00FF88)
                        : const Color(0xFFFF4D6D),
                    width: 3),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                          color: isGood
                              ? const Color(0xFF00FF88)
                              : const Color(0xFFFF4D6D),
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_correctCount / $_actCount',
                      style: TextStyle(
                          color: isGood
                              ? const Color(0xFF00FF88)
                              : const Color(0xFFFF4D6D),
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            scenario.debriefTitle,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          _buildDebriefSection(
              'Points clés à retenir', scenario.keyLessons,
              const Color(0xFF00FF88)),

          const SizedBox(height: 16),

          _buildDebriefSection(
              'Erreurs à éviter', scenario.commonMistakes,
              const Color(0xFFFFB800)),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151B2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Référence légale',
                        style: TextStyle(
                            color: Color(0xFF00BCD4),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scenario.legalReference,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildFinalIndicators(),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context,
                    {'completed': true, 'score': percentage});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Retour à la carte',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDebriefSection(
      String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ',
                        style: TextStyle(color: color, fontSize: 16)),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFinalIndicators() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Indicateurs NUMÉRIX',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildFinalRow('Réputation', _reputation, 100, Colors.green),
          const SizedBox(height: 8),
          _buildFinalRow('Conformité', _compliance, 100, Colors.orange),
          const SizedBox(height: 8),
          _buildFinalRow('Finances', _finance, 100, Colors.blue),
          const SizedBox(height: 8),
          _buildFinalRow('Risque légal', _legalRisk, 100, Colors.red,
              inverted: true),
        ],
      ),
    );
  }

  Widget _buildFinalRow(String label, int value, int max, Color color,
      {bool inverted = false}) {
    final display = inverted ? max - value : value;
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 13)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: display / max,
              backgroundColor: Colors.white12,
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$display/$max',
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════

  void _selectOption(DecisionOption option) {
    setState(() {
      _selectedOptionId = option.id;
      _showConsequence = true;
      _actCompleted = true;

      _reputation =
          (_reputation + option.effect.reputation).clamp(0, 100);
      _compliance =
          (_compliance + option.effect.compliance).clamp(0, 100);
      _finance = (_finance + option.effect.finance).clamp(0, 100);
      _legalRisk =
          (_legalRisk + option.effect.legalRisk).clamp(0, 100);

      if (option.isCorrect) {
        _correctCount++;
        _lastPointsDelta = 10;
      } else {
        _lastPointsDelta = 0;
      }
      _totalPoints += _lastPointsDelta;
      _decisions.add(option.id);
      _showPointsAnim = true;
    });
    _pointsAnimCtrl.forward();
    _autoSave(); // sauvegarde après chaque décision
  }

  void _nextAct() {
    _slideCtrl.reset();
    setState(() {
      _currentActIndex++;
      _selectedOptionId = null;
      _showConsequence = false;
      _actCompleted = false;
      _shuffleOptions();
    });
    _slideCtrl.forward();
    _autoSave(); // sauvegarde après chaque passage d'acte
  }

  void _finishChallenge() {
    setState(() => _challengeFinished = true);
    // Effacer la sauvegarde d'acte en cours (challenge terminé)
    GameSaveService.instance.save(GameSaveData(
      gameId: _gameId,
      authorName: widget.authorName,
      playMode: widget.mode.name,
      challengeStatuses: {},
      challengeScores: {},
      activeChallengeId: null, // plus de challenge actif
      totalPoints: _totalPoints,
      correctCount: _correctCount,
      decisions: List<String>.from(_decisions),
      coachPointsReceived: _coachPointsReceived,
      savedAt: DateTime.now(),
    ));
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF151B2E),
        title: const Text('Quitter le challenge ?',
            style: TextStyle(color: Colors.white)),
        content: Text(
            'Score actuel : $_liveScore% ($_correctCount / $_actCount bonnes réponses). '
            'La progression sera perdue.',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuer',
                style: TextStyle(color: Color(0xFF00BCD4))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quitter',
                style: TextStyle(color: Color(0xFFFF4D6D))),
          ),
        ],
      ),
    );
  }

  String _getRoleName(String roleId) {
    const names = {
      'ceo': 'CEO',
      'juriste': 'Directeur Juridique',
      'dpo': 'DPO',
      'marketing': 'Directeur Marketing',
      'ecommerce': 'Responsable E-Commerce',
    };
    return names[roleId] ?? roleId;
  }
}
