import 'dart:math';
import 'package:flutter/material.dart';
import '../models/clarity_models.dart';
import '../../droit_internet/models/game_models.dart';
import '../../../platform/services/game_save_service.dart';

// ═══════════════════════════════════════════════════════════════
// ÉCRAN DE CHALLENGE — ClarityZone
// Moteur de jeu pour les scénarios de consignes
// ═══════════════════════════════════════════════════════════════

class ClarityChallengeScreen extends StatefulWidget {
  final ClarityChallenge challenge;
  final ClarityPlayMode mode;
  final String? selectedRoleId;
  final ClarityGameSession? session;
  final String authorName;
  final int challengeIndex;   // position dans la séance (1-based)
  final int challengeTotal;   // total de la séance

  const ClarityChallengeScreen({
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
  State<ClarityChallengeScreen> createState() =>
      _ClarityChallengeScreenState();
}

class _ClarityChallengeScreenState extends State<ClarityChallengeScreen>
    with TickerProviderStateMixin {
  int _currentActIndex = 0;
  String? _selectedOptionId;
  bool _showConsequence = false;
  bool _actCompleted = false;
  bool _challengeFinished = false;

  // Indicateurs de performance
  int _clarity = 40;
  int _trust = 60;
  int _efficiency = 55;
  int _stress = 40;

  // Score
  int _correctCount = 0;
  int _totalPoints = 0;
  int _lastPointsDelta = 0;
  bool _showPointsAnim = false;

  // toolTask
  final TextEditingController _taskController = TextEditingController();
  SubmissionStatus? _taskStatus;
  int _coachPointsReceived = 0;

  // ── Sauvegarde ──────────────────────────────────────────────
  static const String _gameId = 'clarity';

  // Historique des décisions (ids des options choisies)
  final List<String> _decisions = [];

  // Options mélangées
  List<ClarityOption> _shuffledOptions = [];
  final _rng = Random();

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late AnimationController _pointsAnimCtrl;
  late Animation<double> _pointsFadeAnim;
  late Animation<Offset> _pointsSlideAnim;

  int get _actCount => widget.challenge.scenario.acts.length;

  ClarityAct? get _currentAct =>
      _currentActIndex < _actCount
          ? widget.challenge.scenario.acts[_currentActIndex]
          : null;

  int get _liveScore =>
      _actCount > 0 ? (_correctCount * 100 / _actCount).round() : 0;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));


    _pointsAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pointsFadeAnim =
        Tween<double>(begin: 1.0, end: 0.0).animate(_pointsAnimCtrl);
    _pointsSlideAnim =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5))
            .animate(CurvedAnimation(
                parent: _pointsAnimCtrl, curve: Curves.easeOut));

    _slideCtrl.forward();
    _shuffleOptions();

    // Écouter les validations formateur
    SubmissionManager.instance.addListener(_onSubmissionUpdate);
    // Restaurer l'état d'une soumission précédente (après rechargement)
    _restoreSubmissionState();
    // Restaurer la sauvegarde de progression
    _loadSave();
  }

  /// Charge la sauvegarde de progression
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
      _clarity          = save.clarity;
      _trust            = save.trust;
      _efficiency       = save.efficiency;
      _stress           = save.stress;
      _totalPoints      = save.totalPoints;
      _correctCount     = save.correctCount;
      _decisions.addAll(save.decisions);
    });
    _shuffleOptions();
  }

  /// Sauvegarde la progression courante
  void _autoSave() {
    GameSaveService.instance.save(GameSaveData(
      gameId: _gameId,
      authorName: widget.authorName,
      playMode: widget.mode == ClarityPlayMode.team ? 'team' : 'solo',
      challengeStatuses: {},
      challengeScores: {},
      activeChallengeId: widget.challenge.id,
      actIndex: _currentActIndex,
      selectedOptionId: _selectedOptionId,
      showConsequence: _showConsequence,
      actCompleted: _actCompleted,
      clarity: _clarity,
      trust: _trust,
      efficiency: _efficiency,
      stress: _stress,
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

  void _onSubmissionUpdate() {
    if (!mounted) return;
    final sub = SubmissionManager.instance.all.lastWhere(
          (s) =>
              s.challengeId == widget.challenge.id &&
              s.authorName == widget.authorName,
          orElse: () => TaskSubmission(
            id: '',
            sessionId: '',
            challengeId: '',
            dayNumber: 0,
            challengeTitle: '',
            toolTask: '',
            responseText: '',
            authorName: '',
            mode: PlayMode.solo,
          ),
        );
    if (sub.id.isNotEmpty && mounted) {
      setState(() {
        _taskStatus = sub.status;
        if (sub.status == SubmissionStatus.validated) {
          final newPts = sub.totalCoachPoints;
          if (newPts > _coachPointsReceived) {
            final delta    = newPts - _coachPointsReceived;
            _totalPoints  += delta;
            _lastPointsDelta = delta;
            _showPointsAnim  = true;
            _pointsAnimCtrl.forward(from: 0);
          }
          _coachPointsReceived = newPts;
        }
      });
    }
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _pointsAnimCtrl.dispose();
    _taskController.dispose();
    SubmissionManager.instance.removeListener(_onSubmissionUpdate);
    super.dispose();
  }

  void _shuffleOptions() {
    if (_currentAct == null) return;
    _shuffledOptions = List<ClarityOption>.from(_currentAct!.options)
      ..shuffle(_rng);
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    if (_challengeFinished) return _buildFinishedScreen();
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: _buildHeader(),
      body: SlideTransition(
        position: _slideAnim,
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: const Color(0xFF161B27),
      elevation: 0,
      leading: TextButton(
        child: const Text('X', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
        onPressed: _confirmExit,
      ),
      title: Row(
        children: [
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
                    // Badge challenge X/Y
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: widget.challenge.color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Challenge ${widget.challengeIndex}/${widget.challengeTotal}',
                        style: TextStyle(
                          color: widget.challenge.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '· Acte ${_currentActIndex + 1}/$_actCount',
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Score badge permanent
          _buildScoreBadge(),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: _actCount > 0 ? (_currentActIndex) / _actCount : 0.0,
            backgroundColor: const Color(0xFF0D1117),
            color: widget.challenge.color,
            minHeight: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.challenge.color.withValues(alpha: 0.3),
                widget.challenge.color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: widget.challenge.color.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_totalPoints pts',
                style: TextStyle(
                    color: widget.challenge.color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$_liveScore%',
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ),
        if (_showPointsAnim)
          SlideTransition(
            position: _pointsSlideAnim,
            child: FadeTransition(
              opacity: _pointsFadeAnim,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _lastPointsDelta > 0
                      ? const Color(0xFF00E676)
                      : Colors.red,
                  borderRadius: BorderRadius.circular(10),
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
      ],
    );
  }

  Widget _buildBody() {
    if (_currentAct == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contexte de l'acte
          _buildActContext(),
          const SizedBox(height: 20),

          // Message personnage
          if (_currentAct!.characterMessage != null)
            _buildCharacterBubble(),
          const SizedBox(height: 20),

          // Contexte de rôle
          if (_currentAct!.roleContext != null) _buildRoleContext(),
          const SizedBox(height: 20),

          // Options de décision
          _buildOptions(),
          const SizedBox(height: 16),

          // Conséquence après choix
          if (_showConsequence && _selectedOptionId != null)
            _buildConsequencePanel(),
          const SizedBox(height: 16),

          // toolTask (exercice pratique)
          if (_actCompleted && _currentAct!.toolTask.isNotEmpty)
            _buildToolTask(),
          const SizedBox(height: 16),

          // Bouton suivant
          if (_actCompleted) _buildNextButton(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActContext() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B27),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: widget.challenge.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.challenge.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentAct!.title,
                  style: TextStyle(
                      color: widget.challenge.color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _currentAct!.narrative,
            style: const TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterBubble() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1033),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF7B1FA2).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                  _currentAct!.characterEmoji ?? '',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                _currentAct!.characterName ?? 'Interlocuteur',
                style: const TextStyle(
                    color: Color(0xFFCE93D8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '"${_currentAct!.characterMessage!}"',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleContext() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2310),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _currentAct!.roleContext!,
              style: const TextStyle(
                  color: Color(0xFFA5D6A7), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Votre décision :',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._shuffledOptions.map((opt) => _buildOptionCard(opt)),
      ],
    );
  }

  Widget _buildOptionCard(ClarityOption opt) {
    final isSelected = _selectedOptionId == opt.id;
    final isCorrect = opt.isCorrect;
    final isRevealed = _showConsequence;

    Color borderColor;
    Color bgColor;

    if (!isRevealed) {
      borderColor = isSelected
          ? widget.challenge.color
          : const Color(0xFF2D3748);
      bgColor = isSelected
          ? widget.challenge.color.withValues(alpha: 0.1)
          : const Color(0xFF161B27);
    } else if (isSelected) {
      borderColor =
          isCorrect ? const Color(0xFF00E676) : const Color(0xFFEF5350);
      bgColor = isCorrect
          ? const Color(0xFF00E676).withValues(alpha: 0.1)
          : const Color(0xFFEF5350).withValues(alpha: 0.1);
    } else if (isCorrect && isRevealed) {
      borderColor = const Color(0xFF00E676).withValues(alpha: 0.4);
      bgColor = const Color(0xFF00E676).withValues(alpha: 0.05);
    } else {
      borderColor = const Color(0xFF2D3748);
      bgColor = const Color(0xFF161B27);
    }

    return GestureDetector(
      onTap: (_actCompleted || isRevealed) ? null : () => _selectOption(opt),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.challenge.color.withValues(alpha: 0.2)
                    : const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: isSelected
                        ? widget.challenge.color
                        : Colors.transparent),
              ),
              child: Center(
                child: isRevealed && isSelected
                    ? Text(
                        isCorrect ? '\u2713' : 'X',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isCorrect
                              ? const Color(0xFF00E676)
                              : const Color(0xFFEF5350),
                        ),
                      )
                    : Text(
                        opt.id.toUpperCase(),
                        style: TextStyle(
                          color: isSelected
                              ? widget.challenge.color
                              : Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt.label,
                    style: TextStyle(
                      color: isRevealed && isCorrect
                          ? const Color(0xFFA5D6A7)
                          : Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  if (isRevealed && isSelected) ...[
                    const SizedBox(height: 6),
                    Text(
                      opt.explanation,
                      style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(ClarityOption opt) {
    setState(() {
      _selectedOptionId = opt.id;
      _showConsequence = true;
      _actCompleted = true;

      // Mise à jour des indicateurs
      _clarity = (_clarity + opt.effect.clarity).clamp(0, 100);
      _trust = (_trust + opt.effect.trust).clamp(0, 100);
      _efficiency = (_efficiency + opt.effect.efficiency).clamp(0, 100);
      _stress = (_stress + opt.effect.stress).clamp(0, 100);

      // Points
      final pts = opt.isCorrect ? 10 : 0;
      if (opt.isCorrect) _correctCount++;
      _totalPoints += pts;
      _lastPointsDelta = pts;

      // Animation points
      _pointsAnimCtrl.reset();
      _showPointsAnim = true;
      _pointsAnimCtrl.forward().then((_) {
        if (mounted) setState(() => _showPointsAnim = false);
      });
    });
    _autoSave(); // sauvegarde après chaque décision
  }

  Widget _buildConsequencePanel() {
    final selected = _shuffledOptions.firstWhere(
        (o) => o.id == _selectedOptionId,
        orElse: () => _shuffledOptions.first);

    final isCorrect = selected.isCorrect;
    final borderColor =
        isCorrect ? const Color(0xFF00E676) : const Color(0xFFEF5350);
    final iconColor = borderColor;
    final iconText = isCorrect ? '\u2713' : 'X';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(iconText, style: TextStyle(color: iconColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Bonne décision !' : 'Décision sous-optimale',
                style: TextStyle(
                    color: iconColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCorrect ? '+10 pts' : '+0 pt',
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            selected.consequence,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, height: 1.5),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 10),
            const Divider(color: Colors.white12),
            const SizedBox(height: 6),
            const Text(
              'La meilleure option était :',
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
            const SizedBox(height: 4),
            ..._shuffledOptions
                .where((o) => o.isCorrect)
                .map((o) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        o.label,
                        style: const TextStyle(
                            color: Color(0xFFA5D6A7),
                            fontSize: 12,
                            height: 1.3),
                      ),
                    )),
          ],
          // Indicateurs
          const SizedBox(height: 12),
          _buildIndicatorChanges(selected),
        ],
      ),
    );
  }

  Widget _buildIndicatorChanges(ClarityOption opt) {
    final items = [
      ('Clarté', opt.effect.clarity),
      ('Confiance', opt.effect.trust),
      ('Efficacité', opt.effect.efficiency),
      ('Stress', opt.effect.stress),
    ];
    final visible = items.where((i) => i.$2 != 0).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: visible.map((item) {
        final label = item.$1;
        final val = item.$2;
        // Stress inversé (+ = mauvais)
        final positive = label == 'Stress' ? val < 0 : val > 0;
        final color =
            positive ? const Color(0xFF00E676) : const Color(0xFFEF5350);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            '$label ${val > 0 ? '+$val' : '$val'}',
            style:
                TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToolTask() {
    if (_currentAct == null) return const SizedBox.shrink();

    final isSubmitted = _taskStatus != null;
    final isValidated = _taskStatus == SubmissionStatus.validated;
    final isRejected = _taskStatus == SubmissionStatus.rejected;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2233),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF1565C0).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Exercice pratique — Validation formateur',
                  style: TextStyle(
                      color: Color(0xFF42A5F5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _currentAct!.toolTask,
            style: const TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),

          if (isValidated) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF00E676).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    ' Validé par le formateur — +$_coachPointsReceived pts',
                    style: const TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ] else if (isRejected) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFEF5350).withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'À revoir — Consultez le feedback de votre formateur.',
                      style: TextStyle(
                          color: Color(0xFFFF8A80), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (isSubmitted) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 4),
                  Text(
                    'En attente de validation par le formateur...',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF161B27),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.3)),
              ),
              child: TextField(
                controller: _taskController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submitTask(),
                decoration: const InputDecoration(
                  hintText: 'Rédigez votre réponse ici...',
                  hintStyle:
                      TextStyle(color: Color(0xFF4A5568), fontSize: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
                child: ElevatedButton(
                onPressed: () => _submitTask(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Envoyer au formateur'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _submitTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    final sub = TaskSubmission(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: widget.session?.sessionId ?? 'session_local',
      challengeId: widget.challenge.id,
      dayNumber: widget.challenge.dayNumber,
      challengeTitle: widget.challenge.title,
      toolTask: _currentAct?.toolTask ?? '',
      responseText: text,
      authorName: widget.authorName,
      mode: widget.mode == ClarityPlayMode.team ? PlayMode.team : PlayMode.solo,
    );
    SubmissionManager.instance.add(sub);
    setState(() => _taskStatus = SubmissionStatus.pending);
  }

  Widget _buildNextButton() {
    final isLastAct = _currentActIndex >= _actCount - 1;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLastAct ? _finishChallenge : _nextAct,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.challenge.color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          isLastAct ? 'Terminer le challenge' : 'Acte suivant',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _nextAct() {
    _slideCtrl.reset();
    setState(() {
      _currentActIndex++;
      _selectedOptionId = null;
      _showConsequence = false;
      _actCompleted = false;
      _taskController.clear();
      _taskStatus = null;
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
      playMode: widget.mode == ClarityPlayMode.team ? 'team' : 'solo',
      challengeStatuses: {},
      challengeScores: {},
      activeChallengeId: null,
      totalPoints: _totalPoints,
      correctCount: _correctCount,
      decisions: List<String>.from(_decisions),
      coachPointsReceived: _coachPointsReceived,
      savedAt: DateTime.now(),
    ));
  }

  // ═══════════════════════════════════════════════════════════════
  // ÉCRAN DE FIN
  // ═══════════════════════════════════════════════════════════════

  Widget _buildFinishedScreen() {
    final scenario = widget.challenge.scenario;
    final grade = _liveScore >= 80
        ? 'Excellent'
        : _liveScore >= 60
            ? 'Bien'
            : _liveScore >= 40
                ? 'Moyen'
                : 'À retravailler';

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Trophy
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.challenge.color.withValues(alpha: 0.3),
                      widget.challenge.color.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: widget.challenge.color.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(widget.challenge.emoji,
                        style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      scenario.debriefTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(grade,
                        style: TextStyle(
                            color: widget.challenge.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatChip(
                            '', '$_totalPoints pts', widget.challenge.color),
                        const SizedBox(width: 12),
                        _buildStatChip('', '$_liveScore%', Colors.green),
                        const SizedBox(width: 12),
                        _buildStatChip(
                            '',
                            '$_correctCount/$_actCount',
                            Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Indicateurs finaux
              _buildFinalIndicators(),

              const SizedBox(height: 24),

              // Leçons clés
              _buildSection(' Leçons clés', scenario.keyLessons,
                  const Color(0xFF42A5F5)),

              const SizedBox(height: 16),

              // Erreurs courantes
              _buildSection('Erreurs à éviter', scenario.commonMistakes,
                  const Color(0xFFFF8A65)),

              const SizedBox(height: 24),

              // Fiche de référence
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B27),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      'Référence : ${scenario.ficheRef}',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, {
                    'completed': true,
                    'score': _liveScore,
                    'totalPoints': _totalPoints,
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.challenge.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Retour à la carte',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String emoji, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFinalIndicators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Indicateurs finaux',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildFinalIndicator('Clarté', _clarity, Colors.blue),
            const SizedBox(width: 8),
            _buildFinalIndicator('Confiance', _trust, Colors.green),
            const SizedBox(width: 8),
            _buildFinalIndicator('Efficacité', _efficiency, Colors.orange),
            const SizedBox(width: 8),
            _buildFinalIndicator('Stress', 100 - _stress, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildFinalIndicator(
      String label, int value, Color color) {
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
            Text('$value',
                style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 9),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 5, right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(item,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4)),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B27),
        title: const Text('Quitter le challenge ?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Score actuel : $_liveScore% ($_totalPoints pts)\n'
          '$_correctCount / $_actCount décisions correctes\n\n'
          'Votre progression sera perdue.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Continuer',
                style:
                    TextStyle(color: widget.challenge.color)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Quitter',
                style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }
}
