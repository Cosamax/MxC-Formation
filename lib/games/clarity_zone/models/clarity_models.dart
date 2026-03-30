import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
// CLARITY ZONE — Modèles de données
// Jeu de rôle sur la gestion des consignes professionnelles
// Basé sur les 20 fiches "Consignes" — MxC Formations
// ═══════════════════════════════════════════════════════════════

// ── Modes de jeu ──────────────────────────────────────────────
enum ClarityPlayMode { solo, team }

// ── Statut d'un challenge ─────────────────────────────────────
enum ClarityChallengeStatus { locked, available, inProgress, completed }

// ── Impact d'une décision ─────────────────────────────────────
enum ClarityImpact { excellent, good, neutral, bad, critical }

// ── Rôles disponibles en mode équipe ─────────────────────────
class ClarityRole {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final String responsibilities;
  final Color color;
  String? playerName;

  ClarityRole({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.responsibilities,
    required this.color,
    this.playerName,
  });
}

// ── Indicateurs de performance ────────────────────────────────
class ClarityIndicators {
  int clarity;      // Clarté de communication (0–100)
  int trust;        // Confiance de l'équipe (0–100)
  int efficiency;   // Efficacité opérationnelle (0–100)
  int stress;       // Niveau de stress / surcharge (0–100, + = mauvais)

  ClarityIndicators({
    this.clarity    = 50,
    this.trust      = 60,
    this.efficiency = 55,
    this.stress     = 40,
  });

  String get riskLevel {
    if (stress > 70 || clarity < 30) return 'Critique';
    if (stress > 50 || clarity < 50) return 'Élevé';
    return 'Maîtrisé';
  }

  Color get riskColor {
    if (stress > 70 || clarity < 30) return const Color(0xFFE53935);
    if (stress > 50 || clarity < 50) return const Color(0xFFFF9800);
    return const Color(0xFF4CAF50);
  }
}

// ── Effet sur les indicateurs après une décision ─────────────
class ClarityEffect {
  final int clarity;
  final int trust;
  final int efficiency;
  final int stress;

  const ClarityEffect({
    this.clarity    = 0,
    this.trust      = 0,
    this.efficiency = 0,
    this.stress     = 0,
  });
}

// ── Option de décision dans un acte ──────────────────────────
class ClarityOption {
  final String id;
  final String label;
  final String explanation;
  final bool isCorrect;
  final ClarityImpact impact;
  final ClarityEffect effect;
  final String consequence;

  const ClarityOption({
    required this.id,
    required this.label,
    required this.explanation,
    required this.isCorrect,
    required this.impact,
    required this.effect,
    required this.consequence,
  });

  ClarityOption copyWith({
    String? label,
    String? explanation,
    bool? isCorrect,
    ClarityImpact? impact,
    ClarityEffect? effect,
    String? consequence,
  }) {
    return ClarityOption(
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

// ── Acte d'un scénario (avec jeu de rôle) ────────────────────
class ClarityAct {
  final String title;
  final String narrative;           // Contexte narratif
  final String? characterMessage;   // Réplique d'un personnage
  final String? characterName;      // Nom du personnage
  final String? characterEmoji;     // Emoji du personnage
  final String? roleContext;        // Ce que fait le joueur dans cet acte
  final List<ClarityOption> options;
  final String toolTask;            // Exercice pratique

  const ClarityAct({
    required this.title,
    required this.narrative,
    this.characterMessage,
    this.characterName,
    this.characterEmoji,
    this.roleContext,
    required this.options,
    required this.toolTask,
  });

  ClarityAct copyWith({
    String? title,
    String? narrative,
    String? characterMessage,
    String? characterName,
    String? characterEmoji,
    String? roleContext,
    List<ClarityOption>? options,
    String? toolTask,
  }) {
    return ClarityAct(
      title: title ?? this.title,
      narrative: narrative ?? this.narrative,
      characterMessage: characterMessage ?? this.characterMessage,
      characterName: characterName ?? this.characterName,
      characterEmoji: characterEmoji ?? this.characterEmoji,
      roleContext: roleContext ?? this.roleContext,
      options: options ?? this.options,
      toolTask: toolTask ?? this.toolTask,
    );
  }
}

// ── Scénario complet d'un challenge ──────────────────────────
class ClarityScenario {
  final String context;             // Mise en situation générale
  final String urgencyMessage;      // Message d'alerte/urgence
  final String roleInstruction;     // Ce que joue l'apprenant
  List<ClarityAct> acts;            // 3 actes de jeu de rôle — mutable pour l'éditeur
  final String debriefTitle;
  final List<String> keyLessons;
  final List<String> commonMistakes;
  final String ficheRef;            // Fiche(s) du cours de référence

  ClarityScenario({
    required this.context,
    required this.urgencyMessage,
    required this.roleInstruction,
    required this.acts,
    required this.debriefTitle,
    required this.keyLessons,
    required this.commonMistakes,
    required this.ficheRef,
  });
}

// ── Challenge ─────────────────────────────────────────────────
class ClarityChallenge {
  final String id;
  final int dayNumber;
  final int orderInDay;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final String ficheRef;
  final ClarityScenario scenario;
  bool isEnabled;
  ClarityChallengeStatus status;
  int? score;

  ClarityChallenge({
    required this.id,
    required this.dayNumber,
    required this.orderInDay,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.ficheRef,
    required this.scenario,
    this.isEnabled = true,
    this.status    = ClarityChallengeStatus.available,
    this.score,
  });
}

// ── Session de jeu ────────────────────────────────────────────
class ClaritySession {
  final String sessionId;
  final ClarityPlayMode mode;
  final String playerName;
  final List<ClarityRole> roles;
  final String formatorCode;
  int totalScore;
  int completedChallenges;
  final ClarityIndicators indicators;
  final DateTime startTime;

  ClaritySession({
    required this.sessionId,
    required this.mode,
    required this.playerName,
    required this.roles,
    required this.formatorCode,
    this.totalScore          = 0,
    this.completedChallenges = 0,
    ClarityIndicators? indicators,
    DateTime? startTime,
  })  : indicators = indicators ?? ClarityIndicators(),
        startTime  = startTime ?? DateTime.now();
}

// ── Session de jeu (alias moderne pour ClarityGameHub) ────────
class ClarityGameSession {
  final String sessionId;
  final ClarityPlayMode mode;
  final String authorName;
  final String formatorCode;
  final String? selectedRoleId;
  int totalScore;
  int completedChallenges;
  final ClarityIndicators indicators;
  final DateTime startTime;

  ClarityGameSession({
    required this.sessionId,
    required this.mode,
    required this.authorName,
    required this.formatorCode,
    this.selectedRoleId,
    this.totalScore          = 0,
    this.completedChallenges = 0,
    ClarityIndicators? indicators,
    DateTime? startTime,
  })  : indicators = indicators ?? ClarityIndicators(),
        startTime  = startTime ?? DateTime.now();
}
