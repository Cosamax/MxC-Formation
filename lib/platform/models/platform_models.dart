import 'package:flutter/material.dart';

// Rôles utilisateurs
enum UserRole { student, professor, admin }

// Accès apprenant à un jeu
class GameAccess {
  final String gameId;
  final AccessStatus status;
  final DateTime grantedAt;
  final String grantedBy; // 'purchase' ou id du formateur

  GameAccess({
    required this.gameId,
    required this.status,
    DateTime? grantedAt,
    this.grantedBy = 'purchase',
  }) : grantedAt = grantedAt ?? DateTime.now();
}

// Statut d'un jeu
enum GameStatus { draft, published, archived }

// Type de question
enum QuestionType { multipleChoice, trueFalse, scenario, fillBlank }

// Niveau de difficulté
enum Difficulty { easy, medium, hard }

// ═══════════════════════════════════════════════════════════════
// MODÈLE UTILISATEUR
// ═══════════════════════════════════════════════════════════════

class PlatformUser {
  final String id;
  final String name;
  final String email;
  final String? passwordHash; // Simulé en local (Firebase en prod)
  final UserRole role;
  final int totalPoints;
  final int gamesPlayed;
  final List<String> badges;
  final Map<String, int> gameScores;
  final List<GameAccess> gameAccesses; // Accès aux jeux achetés/offerts
  final DateTime createdAt;
  final String? avatarColor;

  PlatformUser({
    required this.id,
    required this.name,
    required this.email,
    this.passwordHash,
    required this.role,
    this.totalPoints = 0,
    this.gamesPlayed = 0,
    this.badges = const [],
    this.gameScores = const {},
    this.gameAccesses = const [],
    DateTime? createdAt,
    this.avatarColor,
  }) : createdAt = createdAt ?? DateTime.now();

  bool hasAccessTo(String gameId) {
    return role == UserRole.professor ||
        gameAccesses.any((a) => a.gameId == gameId &&
            (a.status == AccessStatus.granted ||
             a.status == AccessStatus.purchased));
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get color {
    final colors = [
      const Color(0xFF00D4FF),
      const Color(0xFF00FF88),
      const Color(0xFFFFB800),
      const Color(0xFF9C27B0),
      const Color(0xFFFF6B35),
      const Color(0xFFFF4D6D),
    ];
    final hash = name.codeUnits.fold(0, (sum, c) => sum + c);
    return colors[hash % colors.length];
  }

  PlatformUser copyWith({
    int? totalPoints,
    int? gamesPlayed,
    List<String>? badges,
    Map<String, int>? gameScores,
    List<GameAccess>? gameAccesses,
  }) {
    return PlatformUser(
      id: id,
      name: name,
      email: email,
      passwordHash: passwordHash,
      role: role,
      totalPoints: totalPoints ?? this.totalPoints,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      badges: badges ?? this.badges,
      gameScores: gameScores ?? this.gameScores,
      gameAccesses: gameAccesses ?? this.gameAccesses,
      createdAt: createdAt,
      avatarColor: avatarColor,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MODÈLE JEU
// ═══════════════════════════════════════════════════════════════

// Statut d'accès d'un apprenant à un jeu
enum AccessStatus { none, granted, purchased }

class GameInfo {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String domain;
  final Color color;
  final IconData icon;
  final GameStatus status;
  final int totalQuestions;
  final int estimatedMinutes;
  final String difficulty;
  final List<String> skills;
  final List<String> targets;
  final int playCount;
  final double avgScore;
  final String authorName;
  final DateTime createdAt;

  // Tarification
  final double price;           // Prix en euros (0.0 = gratuit)
  final String? stripeProductId; // ID produit Stripe (placeholder)
  final String? stripePriceId;   // ID prix Stripe (placeholder)
  final String? pricingLabel;    // Ex: "49€ / apprenant", "Sur devis"...

  GameInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.domain,
    required this.color,
    required this.icon,
    this.status = GameStatus.published,
    required this.totalQuestions,
    required this.estimatedMinutes,
    required this.difficulty,
    this.skills = const [],
    this.targets = const [],
    this.playCount = 0,
    this.avgScore = 0.0,
    this.authorName = 'MxC Formations',
    DateTime? createdAt,
    this.price = 0.0,
    this.stripeProductId,
    this.stripePriceId,
    this.pricingLabel,
  }) : createdAt = createdAt ?? DateTime.now();

  String get displayPrice {
    if (pricingLabel != null) return pricingLabel!;
    if (price <= 0) return 'Accès libre';
    return '${price.toStringAsFixed(0)} €';
  }

  bool get isFree => price <= 0;
}

// ═══════════════════════════════════════════════════════════════
// MODÈLE SESSION DE JEU
// ═══════════════════════════════════════════════════════════════

class GameSession {
  final String id;
  final String gameId;
  final String sessionCode; // Code 6 chiffres pour rejoindre
  final String professorId;
  final String professorName;
  final DateTime startTime;
  DateTime? endTime;
  final List<StudentResult> results;
  bool isActive;

  GameSession({
    required this.id,
    required this.gameId,
    required this.sessionCode,
    required this.professorId,
    required this.professorName,
    required this.startTime,
    this.endTime,
    this.results = const [],
    this.isActive = true,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }
}

class StudentResult {
  final String studentName;
  final String? teamName;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeSeconds;
  final Map<String, bool> questionResults;
  final DateTime completedAt;

  StudentResult({
    required this.studentName,
    this.teamName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSeconds,
    this.questionResults = const {},
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions * 100) : 0;
}

// ═══════════════════════════════════════════════════════════════
// MODÈLE BADGE
// ═══════════════════════════════════════════════════════════════

class GameBadge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String condition;

  const GameBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.condition,
  });
}

// ═══════════════════════════════════════════════════════════════
// MODÈLE STATISTIQUES PROFESSEUR
// ═══════════════════════════════════════════════════════════════

class ProfessorStats {
  final int totalGames;
  final int totalSessions;
  final int totalStudents;
  final double avgScore;
  final List<GameStat> gameStats;

  const ProfessorStats({
    this.totalGames = 0,
    this.totalSessions = 0,
    this.totalStudents = 0,
    this.avgScore = 0.0,
    this.gameStats = const [],
  });
}

class GameStat {
  final String gameTitle;
  final int sessionCount;
  final int studentCount;
  final double avgScore;
  final Color color;

  const GameStat({
    required this.gameTitle,
    required this.sessionCount,
    required this.studentCount,
    required this.avgScore,
    required this.color,
  });
}

// ═══════════════════════════════════════════════════════════════
// MODÈLE COMPÉTENCE (pour le catalogue extensible)
// ═══════════════════════════════════════════════════════════════

class CompetenceCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> gameIds;

  const CompetenceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.gameIds = const [],
  });
}
