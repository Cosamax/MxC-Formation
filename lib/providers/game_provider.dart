// ============================================================
// LEGAL QUEST — Game Provider (State Management)
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/game_models.dart';
import '../models/question_bank.dart';

class GameProvider extends ChangeNotifier {
  // ── État de la session ──────────────────────────────────
  GameSession? _session;
  List<GameModule> _modules = [];
  int _currentModuleIndex = 0;
  int _currentQuestionIndex = 0;
  String? _selectedAnswerId;
  bool _showExplanation = false;
  bool _isAnswerLocked = false;
  int _remainingSeconds = 30;
  bool _isGameStarted = false;
  bool _isGameOver = false;
  String _gameMode = 'solo'; // 'solo' or 'team'
  int _currentTeamTurnIndex = 0;

  // ── Getters ─────────────────────────────────────────────
  GameSession? get session => _session;
  List<GameModule> get modules => _modules;
  int get currentModuleIndex => _currentModuleIndex;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswerId => _selectedAnswerId;
  bool get showExplanation => _showExplanation;
  bool get isAnswerLocked => _isAnswerLocked;
  int get remainingSeconds => _remainingSeconds;
  bool get isGameStarted => _isGameStarted;
  bool get isGameOver => _isGameOver;
  String get gameMode => _gameMode;
  int get currentTeamTurnIndex => _currentTeamTurnIndex;

  GameModule? get currentModule =>
      _modules.isNotEmpty && _currentModuleIndex < _modules.length
          ? _modules[_currentModuleIndex]
          : null;

  Question? get currentQuestion {
    final mod = currentModule;
    if (mod == null) return null;
    if (_currentQuestionIndex >= mod.questions.length) return null;
    return mod.questions[_currentQuestionIndex];
  }

  Team? get currentTeam {
    if (_session == null || _session!.teams.isEmpty) return null;
    return _session!.teams[_currentTeamTurnIndex % _session!.teams.length];
  }

  List<Team> get rankedTeams {
    if (_session == null) return [];
    final sorted = List<Team>.from(_session!.teams);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  int get totalQuestionsInModule =>
      currentModule?.questions.length ?? 0;

  double get moduleProgress {
    if (totalQuestionsInModule == 0) return 0;
    return _currentQuestionIndex / totalQuestionsInModule;
  }

  double get gameProgress {
    final totalModules = _modules.length;
    if (totalModules == 0) return 0;
    return (_currentModuleIndex + moduleProgress) / totalModules;
  }

  // ── Initialisation ───────────────────────────────────────
  void initGame({required List<Team> teams, required String mode}) {
    _gameMode = mode;
    _session = GameSession(teams: teams);
    _currentTeamTurnIndex = 0;
    _buildModules();
    _isGameStarted = true;
    _isGameOver = false;
    _currentModuleIndex = 0;
    _currentQuestionIndex = 0;
    _resetQuestionState();
    notifyListeners();
  }

  void _buildModules() {
    _modules = [
      GameModule(
        id: 'module1',
        title: 'Fondamentaux',
        subtitle: 'Fiches 1-3',
        description: 'Cadre juridique, nom de domaine, propriété intellectuelle',
        theme: ModuleTheme.fondamentaux,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.fondamentaux),
        icon: '⚖️',
        durationMinutes: 25,
      ),
      GameModule(
        id: 'module2',
        title: 'RGPD & Données',
        subtitle: 'Fiches 4-5',
        description: 'Protection des données personnelles, cookies, CNIL',
        theme: ModuleTheme.donneesRGPD,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.donneesRGPD),
        icon: '🔒',
        durationMinutes: 25,
      ),
      GameModule(
        id: 'module3',
        title: 'Contrat & Conso.',
        subtitle: 'Fiches 6-10',
        description: 'E-mailing, mentions légales, CGV, vente à distance',
        theme: ModuleTheme.contratConsommateur,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.contratConsommateur),
        icon: '📋',
        durationMinutes: 30,
      ),
      GameModule(
        id: 'module4',
        title: 'Pratiques & Droits',
        subtitle: 'Fiches 11-15',
        description: 'Rétractation, publicité, contrat électronique, sanctions',
        theme: ModuleTheme.pratiquesPublicite,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.pratiquesPublicite),
        icon: '📢',
        durationMinutes: 30,
      ),
      GameModule(
        id: 'module5',
        title: 'Contenus & Réputation',
        subtitle: 'Fiches 16-19',
        description: 'UGC, avis clients, droit pénal, e-réputation',
        theme: ModuleTheme.contenuReputation,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.contenuReputation),
        icon: '🌐',
        durationMinutes: 25,
      ),
      GameModule(
        id: 'module6',
        title: 'Grand Final',
        subtitle: 'Fiche 20 — DIGIT\'SHOP EN CRISE',
        description: 'Scénarios de crise, checklist finale, décision collective',
        theme: ModuleTheme.grandFinal,
        questions: QuestionBank.getModuleQuestions(ModuleTheme.grandFinal),
        icon: '🚨',
        durationMinutes: 20,
      ),
    ];
  }

  // ── Actions de jeu ────────────────────────────────────────
  void selectAnswer(String answerId) {
    if (_isAnswerLocked) return;
    _selectedAnswerId = answerId;
    _isAnswerLocked = true;
    _showExplanation = true;

    final q = currentQuestion;
    if (q != null && _session != null) {
      final isCorrect = answerId == q.correctAnswerId;
      final team = currentTeam;
      if (team != null) {
        team.recordAnswer(isCorrect);
        if (isCorrect) {
          // Bonus points for speed
          final speedBonus = (_remainingSeconds / q.timeSeconds * 50).round();
          team.addPoints(q.points + speedBonus);
        }
      }
    }
    notifyListeners();
  }

  void nextQuestion() {
    final mod = currentModule;
    if (mod == null) return;

    // Advance team turn in team mode
    if (_gameMode == 'team' && _session != null) {
      _currentTeamTurnIndex =
          (_currentTeamTurnIndex + 1) % _session!.teams.length;
    }

    if (_currentQuestionIndex < mod.questions.length - 1) {
      _currentQuestionIndex++;
      _resetQuestionState();
    } else {
      _nextModule();
    }
    notifyListeners();
  }

  void _nextModule() {
    if (_currentModuleIndex < _modules.length - 1) {
      _currentModuleIndex++;
      _currentQuestionIndex = 0;
      _resetQuestionState();
    } else {
      _isGameOver = true;
    }
    notifyListeners();
  }

  void skipToModule(int moduleIndex) {
    if (moduleIndex >= 0 && moduleIndex < _modules.length) {
      _currentModuleIndex = moduleIndex;
      _currentQuestionIndex = 0;
      _resetQuestionState();
      notifyListeners();
    }
  }

  void _resetQuestionState() {
    _selectedAnswerId = null;
    _showExplanation = false;
    _isAnswerLocked = false;
    _remainingSeconds = currentQuestion?.timeSeconds ?? 30;
  }

  void updateTimer(int seconds) {
    _remainingSeconds = seconds;
    notifyListeners();
  }

  void timeUp() {
    if (!_isAnswerLocked) {
      _isAnswerLocked = true;
      _showExplanation = true;
      final team = currentTeam;
      team?.recordAnswer(false);
      notifyListeners();
    }
  }

  void resetGame() {
    _session = null;
    _modules = [];
    _currentModuleIndex = 0;
    _currentQuestionIndex = 0;
    _isGameStarted = false;
    _isGameOver = false;
    _resetQuestionState();
    notifyListeners();
  }
}
