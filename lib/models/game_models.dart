// ============================================================
// LEGAL QUEST — DIGIT'SHOP Business Game
// Modèles de données
// ============================================================

enum QuestionType { qcm, trueFalse, scenario, flashChallenge }
enum Difficulty { easy, medium, hard }
enum ModuleTheme {
  fondamentaux,
  donneesRGPD,
  contratConsommateur,
  pratiquesPublicite,
  contenuReputation,
  grandFinal,
}

// ─────────────────────────────────────────────────────────────
// MODÈLE : Réponse
// ─────────────────────────────────────────────────────────────
class Answer {
  final String id;
  final String text;
  final bool isCorrect;
  final String? explanation;

  const Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.explanation,
  });
}

// ─────────────────────────────────────────────────────────────
// MODÈLE : Question
// ─────────────────────────────────────────────────────────────
class Question {
  final String id;
  final String questionText;
  final QuestionType type;
  final Difficulty difficulty;
  final List<Answer> answers;
  final String correctAnswerId;
  final String explanation;
  final String ficheReference;
  final ModuleTheme module;
  final int points;
  final int timeSeconds;

  const Question({
    required this.id,
    required this.questionText,
    required this.type,
    required this.difficulty,
    required this.answers,
    required this.correctAnswerId,
    required this.explanation,
    required this.ficheReference,
    required this.module,
    required this.points,
    required this.timeSeconds,
  });
}

// ─────────────────────────────────────────────────────────────
// MODÈLE : Module de jeu
// ─────────────────────────────────────────────────────────────
class GameModule {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final ModuleTheme theme;
  final List<Question> questions;
  final String icon;
  final int durationMinutes;

  const GameModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.theme,
    required this.questions,
    required this.icon,
    required this.durationMinutes,
  });

  int get totalPoints =>
      questions.fold(0, (sum, q) => sum + q.points);
}

// ─────────────────────────────────────────────────────────────
// MODÈLE : Équipe
// ─────────────────────────────────────────────────────────────
class Team {
  final String id;
  String name;
  int score;
  int correctAnswers;
  int totalAnswered;
  List<String> badges;
  int streakCount;

  Team({
    required this.id,
    required this.name,
    this.score = 0,
    this.correctAnswers = 0,
    this.totalAnswered = 0,
    List<String>? badges,
    this.streakCount = 0,
  }) : badges = badges ?? [];

  double get accuracy =>
      totalAnswered == 0 ? 0 : correctAnswers / totalAnswered;

  void addPoints(int pts) => score += pts;

  void recordAnswer(bool correct) {
    totalAnswered++;
    if (correct) {
      correctAnswers++;
      streakCount++;
      if (streakCount == 3) badges.add('🔥 Série 3');
      if (streakCount == 5) badges.add('⚡ Série 5');
    } else {
      streakCount = 0;
    }
  }

  Team copyWith({String? name, int? score}) {
    return Team(
      id: id,
      name: name ?? this.name,
      score: score ?? this.score,
      correctAnswers: correctAnswers,
      totalAnswered: totalAnswered,
      badges: badges,
      streakCount: streakCount,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MODÈLE : Session de jeu
// ─────────────────────────────────────────────────────────────
class GameSession {
  final List<Team> teams;
  int currentModuleIndex;
  int currentQuestionIndex;
  bool isGameOver;
  DateTime startTime;
  Map<String, List<String>> teamAnswers; // teamId -> [answerId]

  GameSession({
    required this.teams,
    this.currentModuleIndex = 0,
    this.currentQuestionIndex = 0,
    this.isGameOver = false,
    Map<String, List<String>>? teamAnswers,
  })  : startTime = DateTime.now(),
        teamAnswers = teamAnswers ?? {};

  Team? get leadingTeam {
    if (teams.isEmpty) return null;
    return teams.reduce((a, b) => a.score >= b.score ? a : b);
  }

  Duration get elapsed => DateTime.now().difference(startTime);
}
