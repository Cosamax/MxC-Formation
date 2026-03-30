import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// SERVICE DE SAUVEGARDE DE PROGRESSION EN JEU
// Persiste et restaure l'état complet d'une partie pour les deux
// jeux (Numérix / ClarityZone) afin que le joueur puisse
// reprendre exactement là où il s'était arrêté.
// ═══════════════════════════════════════════════════════════════

/// Snapshot de l'état d'une partie en cours
class GameSaveData {
  // ── Identité session ─────────────────────────────────────────
  final String gameId;         // 'numerix' | 'clarity'
  final String authorName;
  final String playMode;       // 'solo' | 'team'
  final String? roleId;

  // ── Progression carte des challenges ─────────────────────────
  /// Map challengeId → statut ('available' | 'inProgress' | 'completed')
  final Map<String, String> challengeStatuses;
  /// Map challengeId → score (0–100)
  final Map<String, int> challengeScores;

  // ── Challenge en cours (si une partie est ouverte) ────────────
  final String? activeChallengeId;
  final int    actIndex;         // acte courant
  final String? selectedOptionId;
  final bool   showConsequence;
  final bool   actCompleted;

  // ── Indicateurs Numérix ───────────────────────────────────────
  final int reputation;
  final int compliance;
  final int finance;
  final int legalRisk;

  // ── Indicateurs ClarityZone ───────────────────────────────────
  final int clarity;
  final int trust;
  final int efficiency;
  final int stress;

  // ── Score global ─────────────────────────────────────────────
  final int totalPoints;
  final int correctCount;
  final List<String> decisions;  // ids des options choisies (ordre chronologique)

  // ── Points coach déjà reçus ───────────────────────────────────
  final int coachPointsReceived;

  // ── Horodatage ───────────────────────────────────────────────
  final DateTime savedAt;
  final bool gameFinished;       // true = l'utilisateur a déclaré fin de partie

  const GameSaveData({
    required this.gameId,
    required this.authorName,
    required this.playMode,
    this.roleId,
    required this.challengeStatuses,
    required this.challengeScores,
    this.activeChallengeId,
    this.actIndex = 0,
    this.selectedOptionId,
    this.showConsequence = false,
    this.actCompleted = false,
    this.reputation = 75,
    this.compliance = 40,
    this.finance = 70,
    this.legalRisk = 60,
    this.clarity = 50,
    this.trust = 50,
    this.efficiency = 50,
    this.stress = 50,
    this.totalPoints = 0,
    this.correctCount = 0,
    this.decisions = const [],
    this.coachPointsReceived = 0,
    required this.savedAt,
    this.gameFinished = false,
  });

  // ── Sérialisation ────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'authorName': authorName,
    'playMode': playMode,
    'roleId': roleId,
    'challengeStatuses': challengeStatuses,
    'challengeScores': challengeScores,
    'activeChallengeId': activeChallengeId,
    'actIndex': actIndex,
    'selectedOptionId': selectedOptionId,
    'showConsequence': showConsequence,
    'actCompleted': actCompleted,
    'reputation': reputation,
    'compliance': compliance,
    'finance': finance,
    'legalRisk': legalRisk,
    'clarity': clarity,
    'trust': trust,
    'efficiency': efficiency,
    'stress': stress,
    'totalPoints': totalPoints,
    'correctCount': correctCount,
    'decisions': decisions,
    'coachPointsReceived': coachPointsReceived,
    'savedAt': savedAt.toIso8601String(),
    'gameFinished': gameFinished,
  };

  factory GameSaveData.fromJson(Map<String, dynamic> j) => GameSaveData(
    gameId:            j['gameId'] as String,
    authorName:        j['authorName'] as String,
    playMode:          j['playMode'] as String,
    roleId:            j['roleId'] as String?,
    challengeStatuses: Map<String, String>.from(
        (j['challengeStatuses'] as Map?) ?? {}),
    challengeScores:   Map<String, int>.from(
        (j['challengeScores'] as Map?)?.map(
            (k, v) => MapEntry(k as String, (v as num).toInt())) ?? {}),
    activeChallengeId: j['activeChallengeId'] as String?,
    actIndex:          (j['actIndex'] as num?)?.toInt() ?? 0,
    selectedOptionId:  j['selectedOptionId'] as String?,
    showConsequence:   (j['showConsequence'] as bool?) ?? false,
    actCompleted:      (j['actCompleted'] as bool?) ?? false,
    reputation:        (j['reputation'] as num?)?.toInt() ?? 75,
    compliance:        (j['compliance'] as num?)?.toInt() ?? 40,
    finance:           (j['finance'] as num?)?.toInt() ?? 70,
    legalRisk:         (j['legalRisk'] as num?)?.toInt() ?? 60,
    clarity:           (j['clarity'] as num?)?.toInt() ?? 50,
    trust:             (j['trust'] as num?)?.toInt() ?? 50,
    efficiency:        (j['efficiency'] as num?)?.toInt() ?? 50,
    stress:            (j['stress'] as num?)?.toInt() ?? 50,
    totalPoints:       (j['totalPoints'] as num?)?.toInt() ?? 0,
    correctCount:      (j['correctCount'] as num?)?.toInt() ?? 0,
    decisions:         List<String>.from((j['decisions'] as List?) ?? []),
    coachPointsReceived: (j['coachPointsReceived'] as num?)?.toInt() ?? 0,
    savedAt:           DateTime.parse(j['savedAt'] as String),
    gameFinished:      (j['gameFinished'] as bool?) ?? false,
  );
}

// ─────────────────────────────────────────────────────────────
class GameSaveService {
  GameSaveService._();
  static final GameSaveService instance = GameSaveService._();

  static const String _prefix = 'game_save_';

  // ── Clé de sauvegarde : une par (jeu, joueur) ───────────────
  static String _key(String gameId, String authorName) =>
      '${_prefix}${gameId}_${authorName.toLowerCase().replaceAll(' ', '_')}';

  // ── Sauvegarder ─────────────────────────────────────────────
  Future<void> save(GameSaveData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _key(data.gameId, data.authorName), json.encode(data.toJson()));
    } catch (_) {}
  }

  // ── Charger ─────────────────────────────────────────────────
  Future<GameSaveData?> load(String gameId, String authorName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(gameId, authorName));
      if (raw == null) return null;
      return GameSaveData.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ── Vérifier s'il existe une sauvegarde non terminée ────────
  Future<bool> hasSave(String gameId, String authorName) async {
    final save = await load(gameId, authorName);
    return save != null && !save.gameFinished;
  }

  // ── Effacer (fin de partie ou reset) ────────────────────────
  Future<void> clear(String gameId, String authorName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key(gameId, authorName));
    } catch (_) {}
  }

  // ── Marquer la partie comme terminée ────────────────────────
  Future<void> markFinished(String gameId, String authorName) async {
    final existing = await load(gameId, authorName);
    if (existing == null) return;
    await save(GameSaveData(
      gameId: existing.gameId,
      authorName: existing.authorName,
      playMode: existing.playMode,
      roleId: existing.roleId,
      challengeStatuses: existing.challengeStatuses,
      challengeScores: existing.challengeScores,
      totalPoints: existing.totalPoints,
      correctCount: existing.correctCount,
      decisions: existing.decisions,
      coachPointsReceived: existing.coachPointsReceived,
      savedAt: DateTime.now(),
      gameFinished: true,
    ));
  }

  // ── Lister toutes les sauvegardes (pour admin) ───────────────
  Future<List<GameSaveData>> listAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
      final result = <GameSaveData>[];
      for (final k in keys) {
        try {
          final raw = prefs.getString(k);
          if (raw != null) {
            result.add(GameSaveData.fromJson(
                json.decode(raw) as Map<String, dynamic>));
          }
        } catch (_) {}
      }
      return result;
    } catch (_) {
      return [];
    }
  }
}
