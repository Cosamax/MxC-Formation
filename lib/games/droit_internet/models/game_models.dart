import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// MODES DE JEU
// ═══════════════════════════════════════════════════════════════

enum PlayMode { solo, team }
enum ChallengeStatus { locked, available, inProgress, completed }
enum DecisionImpact { positive, negative, neutral, critical }
enum IndicatorType { reputation, compliance, finance, legal }

// ═══════════════════════════════════════════════════════════════
// ENTREPRISE DE L'APPRENANT
// ═══════════════════════════════════════════════════════════════

class PlayerCompany {
  final String name;
  final String logoEmoji;   // Emoji choisi comme logo rapide
  final String logoColor;   // Couleur hex choisie
  final String sector;
  final String tagline;

  // Indicateurs vivants (0-100)
  int reputation;
  int compliance;
  int finance;
  int legalRisk; // 0 = pas de risque, 100 = procès imminent

  PlayerCompany({
    required this.name,
    required this.logoEmoji,
    required this.logoColor,
    required this.sector,
    this.tagline = '',
    this.reputation = 75,
    this.compliance = 40, // Commence bas — beaucoup à corriger
    this.finance = 70,
    this.legalRisk = 60,  // Commence haut — l'entreprise est en danger
  });

  PlayerCompany copyWith({
    int? reputation,
    int? compliance,
    int? finance,
    int? legalRisk,
  }) {
    return PlayerCompany(
      name: name,
      logoEmoji: logoEmoji,
      logoColor: logoColor,
      sector: sector,
      tagline: tagline,
      reputation: (reputation ?? this.reputation).clamp(0, 100),
      compliance: (compliance ?? this.compliance).clamp(0, 100),
      finance: (finance ?? this.finance).clamp(0, 100),
      legalRisk: (legalRisk ?? this.legalRisk).clamp(0, 100),
    );
  }

  String get riskLevel {
    if (legalRisk >= 80) return 'CRITIQUE';
    if (legalRisk >= 60) return 'ÉLEVÉ';
    if (legalRisk >= 40) return 'MODÉRÉ';
    return 'FAIBLE';
  }

  Color get riskColor {
    if (legalRisk >= 80) return const Color(0xFFFF4D6D);
    if (legalRisk >= 60) return const Color(0xFFFFB800);
    if (legalRisk >= 40) return const Color(0xFF00D4FF);
    return const Color(0xFF00FF88);
  }
}

// ═══════════════════════════════════════════════════════════════
// RÔLES EN MODE ÉQUIPE
// ═══════════════════════════════════════════════════════════════

class TeamRole {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final List<String> responsibilities;
  final Color color;
  String playerName;

  TeamRole({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.responsibilities,
    required this.color,
    this.playerName = '',
  });
}

// ═══════════════════════════════════════════════════════════════
// CHALLENGE
// ═══════════════════════════════════════════════════════════════

class Challenge {
  final String id;
  final int dayNumber;       // 1, 2 ou 3
  final int orderInDay;      // 1 à 5
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<String> fichesRef; // Ex: ["Fiche 1", "Fiche 7"]
  final String toolName;
  final String toolUrl;
  final CrisisScenario scenario;
  bool isEnabled;            // Contrôlé par le formateur
  ChallengeStatus status;
  int? score;
  Map<String, dynamic> decisions; // Décisions prises par l'apprenant

  Challenge({
    required this.id,
    required this.dayNumber,
    required this.orderInDay,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.fichesRef,
    required this.toolName,
    required this.toolUrl,
    required this.scenario,
    this.isEnabled = true,
    this.status = ChallengeStatus.locked,
    this.score,
    Map<String, dynamic>? decisions,
  }) : decisions = decisions ?? {};
}

// ═══════════════════════════════════════════════════════════════
// SCÉNARIO DE CRISE
// ═══════════════════════════════════════════════════════════════

class CrisisScenario {
  final String context;          // Mise en situation narrative
  final String urgencyMessage;   // Message d'alerte
  final String roleInstructions; // Ce que chaque rôle doit faire
  List<CrisisAct> acts;         // Les actes du scénario (3 actes) — mutable pour l'éditeur
  final String debriefTitle;
  final List<String> keyLessons; // Points clés à retenir
  final List<String> commonMistakes;
  final String legalReference;   // La règle juridique concernée

  CrisisScenario({
    required this.context,
    required this.urgencyMessage,
    required this.roleInstructions,
    required this.acts,
    required this.debriefTitle,
    required this.keyLessons,
    required this.commonMistakes,
    required this.legalReference,
  });
}

// ═══════════════════════════════════════════════════════════════
// ACTE D'UN SCÉNARIO
// ═══════════════════════════════════════════════════════════════

class CrisisAct {
  final String title;
  final String narrative;        // Texte narratif immersif
  final String? characterMessage; // Message d'un personnage (avocat, client, CNIL...)
  final String? characterName;
  final String? characterEmoji;
  final List<DecisionOption> options;
  final String toolTask;         // Ce que l'apprenant doit faire avec l'outil

  const CrisisAct({
    required this.title,
    required this.narrative,
    this.characterMessage,
    this.characterName,
    this.characterEmoji,
    required this.options,
    required this.toolTask,
  });

  CrisisAct copyWith({
    String? title,
    String? narrative,
    String? characterMessage,
    String? characterName,
    String? characterEmoji,
    List<DecisionOption>? options,
    String? toolTask,
  }) {
    return CrisisAct(
      title: title ?? this.title,
      narrative: narrative ?? this.narrative,
      characterMessage: characterMessage ?? this.characterMessage,
      characterName: characterName ?? this.characterName,
      characterEmoji: characterEmoji ?? this.characterEmoji,
      options: options ?? this.options,
      toolTask: toolTask ?? this.toolTask,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// OPTION DE DÉCISION
// ═══════════════════════════════════════════════════════════════

class DecisionOption {
  final String id;
  final String label;
  final String explanation;
  final bool isCorrect;
  final DecisionImpact impact;
  final IndicatorEffect effect;
  final String consequence; // Ce qui se passe si on choisit cette option

  const DecisionOption({
    required this.id,
    required this.label,
    required this.explanation,
    required this.isCorrect,
    required this.impact,
    required this.effect,
    required this.consequence,
  });

  DecisionOption copyWith({
    String? label,
    String? explanation,
    bool? isCorrect,
    DecisionImpact? impact,
    IndicatorEffect? effect,
    String? consequence,
  }) {
    return DecisionOption(
      id: id,
      label: label ?? this.label,
      explanation: explanation ?? this.explanation,
      isCorrect: isCorrect ?? this.isCorrect,
      impact: impact ?? this.impact,
      effect: effect ?? this.effect,
      consequence: consequence ?? this.consequence,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EFFET SUR LES INDICATEURS
// ═══════════════════════════════════════════════════════════════

class IndicatorEffect {
  final int reputation;
  final int compliance;
  final int finance;
  final int legalRisk;

  const IndicatorEffect({
    this.reputation = 0,
    this.compliance = 0,
    this.finance = 0,
    this.legalRisk = 0,
  });
}

// ═══════════════════════════════════════════════════════════════
// SESSION DE JEU
// ═══════════════════════════════════════════════════════════════

class DroitGameSession {
  final String sessionId;
  final PlayMode mode;
  final PlayerCompany company;
  final List<TeamRole> roles;
  final String formatorCode;
  int totalScore;
  int completedChallenges;
  final DateTime startTime;

  DroitGameSession({
    required this.sessionId,
    required this.mode,
    required this.company,
    required this.roles,
    required this.formatorCode,
    this.totalScore = 0,
    this.completedChallenges = 0,
    DateTime? startTime,
  }) : startTime = startTime ?? DateTime.now();
}

// ═══════════════════════════════════════════════════════════════
// SOUMISSION D'EXERCICE (toolTask) PAR UN APPRENANT / GROUPE
// ═══════════════════════════════════════════════════════════════

enum SubmissionStatus { pending, validated, rejected }

class TaskSubmission {
  final String id;
  final String sessionId;
  final String challengeId;
  final int dayNumber;
  final String challengeTitle;
  final String toolTask;        // énoncé de l'exercice
  final String responseText;    // réponse rédigée par l'apprenant/groupe
  final String authorName;      // nom apprenant ou nom équipe
  final PlayMode mode;          // solo ou team
  SubmissionStatus status;
  int coachScore;               // 0–20 pts attribués par le formateur
  bool bonusAwarded;            // +5 pts bonus qualité
  String coachComment;          // commentaire optionnel du formateur
  final DateTime submittedAt;
  DateTime? validatedAt;

  TaskSubmission({
    required this.id,
    required this.sessionId,
    required this.challengeId,
    required this.dayNumber,
    required this.challengeTitle,
    required this.toolTask,
    required this.responseText,
    required this.authorName,
    required this.mode,
    this.status = SubmissionStatus.pending,
    this.coachScore = 0,
    this.bonusAwarded = false,
    this.coachComment = '',
    DateTime? submittedAt,
    this.validatedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  // ── Sérialisation JSON ──────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id,
    'sessionId': sessionId,
    'challengeId': challengeId,
    'dayNumber': dayNumber,
    'challengeTitle': challengeTitle,
    'toolTask': toolTask,
    'responseText': responseText,
    'authorName': authorName,
    'mode': mode.name,
    'status': status.name,
    'coachScore': coachScore,
    'bonusAwarded': bonusAwarded,
    'coachComment': coachComment,
    'submittedAt': submittedAt.toIso8601String(),
    'validatedAt': validatedAt?.toIso8601String(),
  };

  factory TaskSubmission.fromJson(Map<String, dynamic> j) {
    final sub = TaskSubmission(
      id: j['id'] as String,
      sessionId: j['sessionId'] as String,
      challengeId: j['challengeId'] as String,
      dayNumber: j['dayNumber'] as int,
      challengeTitle: j['challengeTitle'] as String,
      toolTask: j['toolTask'] as String,
      responseText: j['responseText'] as String,
      authorName: j['authorName'] as String,
      mode: PlayMode.values.firstWhere(
          (m) => m.name == j['mode'], orElse: () => PlayMode.solo),
      submittedAt: DateTime.parse(j['submittedAt'] as String),
      validatedAt: j['validatedAt'] != null
          ? DateTime.parse(j['validatedAt'] as String)
          : null,
    );
    sub.status = SubmissionStatus.values.firstWhere(
        (s) => s.name == j['status'], orElse: () => SubmissionStatus.pending);
    sub.coachScore   = (j['coachScore'] as int?) ?? 0;
    sub.bonusAwarded = (j['bonusAwarded'] as bool?) ?? false;
    sub.coachComment = (j['coachComment'] as String?) ?? '';
    return sub;
  }

  /// Points totaux attribués par le formateur (score + bonus éventuel)
  int get totalCoachPoints => coachScore + (bonusAwarded ? 5 : 0);

  /// Label de statut lisible
  String get statusLabel {
    switch (status) {
      case SubmissionStatus.pending:   return 'En attente';
      case SubmissionStatus.validated: return 'Validé';
      case SubmissionStatus.rejected:  return 'À revoir';
    }
  }

  /// Couleur associée au statut
  static const Map<SubmissionStatus, int> statusColors = {
    SubmissionStatus.pending:   0xFFFF9800,
    SubmissionStatus.validated: 0xFF4CAF50,
    SubmissionStatus.rejected:  0xFFE53935,
  };
}

// ═══════════════════════════════════════════════════════════════
// GESTIONNAIRE GLOBAL DES SOUMISSIONS (singleton persistant)
// ═══════════════════════════════════════════════════════════════

class SubmissionManager {
  SubmissionManager._();
  static final SubmissionManager instance = SubmissionManager._();

  static const String _prefsKey = 'task_submissions_v1';

  final List<TaskSubmission> _submissions = [];
  bool _loaded = false;

  List<TaskSubmission> get all => List.unmodifiable(_submissions);

  List<TaskSubmission> get pending =>
      _submissions.where((s) => s.status == SubmissionStatus.pending).toList();

  List<TaskSubmission> forSession(String sessionId) =>
      _submissions.where((s) => s.sessionId == sessionId).toList();

  // ── Chargement depuis SharedPreferences ──────────────────────
  /// À appeler une seule fois au démarrage de l'app (main.dart)
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null) {
        final list = json.decode(raw) as List<dynamic>;
        for (final item in list) {
          try {
            _submissions.add(
                TaskSubmission.fromJson(item as Map<String, dynamic>));
          } catch (_) {
            // Entrée corrompue : ignorée
          }
        }
        _notifyListeners();
      }
    } catch (_) {
      // Erreur de lecture : on repart de zéro
    }
  }

  // ── Sauvegarde dans SharedPreferences ────────────────────────
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = json.encode(_submissions.map((s) => s.toJson()).toList());
      await prefs.setString(_prefsKey, raw);
    } catch (_) {
      // Erreur silencieuse
    }
  }

  /// Ajoute une nouvelle soumission
  void add(TaskSubmission submission) {
    // Éviter les doublons (double-tap sur Envoyer)
    if (_submissions.any((s) => s.id == submission.id)) return;
    _submissions.add(submission);
    _notifyListeners();
    _persist();
  }

  /// Le formateur valide une soumission et attribue des points
  /// Retourne le nombre de points crédités
  int validate({
    required String submissionId,
    required int score,          // 0–20
    required bool bonus,         // +5 qualité
    required String comment,
  }) {
    final idx = _submissions.indexWhere((s) => s.id == submissionId);
    if (idx == -1) return 0;

    final sub = _submissions[idx];
    sub.status        = SubmissionStatus.validated;
    sub.coachScore    = score.clamp(0, 20);
    sub.bonusAwarded  = bonus;
    sub.coachComment  = comment;
    sub.validatedAt   = DateTime.now();

    final pts = sub.totalCoachPoints;
    _notifyListeners();
    _persist();
    return pts;
  }

  /// Le formateur renvoie une soumission pour révision
  void reject({required String submissionId, required String comment}) {
    final idx = _submissions.indexWhere((s) => s.id == submissionId);
    if (idx == -1) return;
    _submissions[idx].status       = SubmissionStatus.rejected;
    _submissions[idx].coachComment = comment;
    _notifyListeners();
    _persist();
  }

  // ── Listeners (pour mise à jour réactive de l'UI) ──────────────
  final List<void Function()> _listeners = [];
  void addListener(void Function() fn)    => _listeners.add(fn);
  void removeListener(void Function() fn) => _listeners.remove(fn);
  void _notifyListeners() { for (final fn in _listeners) fn(); }

  // Réinitialise pour une nouvelle session (et efface la persistance)
  Future<void> clear() async {
    _submissions.clear();
    _notifyListeners();
    await _persist();
  }
}
