import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/platform_models.dart';
import '../data/games_data.dart';
import 'dart:math';

class PlatformProvider extends ChangeNotifier {
  // ─── État courant ───
  PlatformUser? _currentUser;
  String? _activeRole; // 'student' | 'professor'
  List<GameSession> _sessions = [];
  String? _activeSessionCode;
  bool _isLoading = false;

  // ─── Base d'utilisateurs (persistée via SharedPreferences) ───
  final List<PlatformUser> _registeredUsers = [];

  // Statistiques simulées
  final List<StudentResult> _allResults = [];

  // Clé SharedPreferences
  static const String _usersKey = 'registered_users_v1';

  PlatformProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadUsers();
    _ensureTestAccount();
    notifyListeners();
  }

  // ─── Persistance des comptes ──────────────────────────────────

  Future<void> _loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_usersKey);
      if (raw != null) {
        final List<dynamic> list = json.decode(raw);
        for (final item in list) {
          final m = item as Map<String, dynamic>;
          _registeredUsers.add(PlatformUser(
            id: m['id'] as String,
            name: m['name'] as String,
            email: m['email'] as String,
            passwordHash: m['passwordHash'] as String?,
            role: UserRole.values.firstWhere(
              (r) => r.name == (m['role'] as String),
              orElse: () => UserRole.student,
            ),
            totalPoints: (m['totalPoints'] as int?) ?? 0,
            gamesPlayed: (m['gamesPlayed'] as int?) ?? 0,
            gameAccesses: ((m['gameAccesses'] as List?) ?? []).map((a) {
              final am = a as Map<String, dynamic>;
              return GameAccess(
                gameId: am['gameId'] as String,
                status: AccessStatus.values.firstWhere(
                  (s) => s.name == (am['status'] as String),
                  orElse: () => AccessStatus.granted,
                ),
                grantedBy: am['grantedBy'] as String? ?? 'system',
              );
            }).toList(),
          ));
        }
      }
    } catch (_) {}
  }

  Future<void> _saveUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _registeredUsers.map((u) => {
        'id': u.id,
        'name': u.name,
        'email': u.email,
        'passwordHash': u.passwordHash,
        'role': u.role.name,
        'totalPoints': u.totalPoints,
        'gamesPlayed': u.gamesPlayed,
        'gameAccesses': u.gameAccesses.map((a) => {
          'gameId': a.gameId,
          'status': a.status.name,
          'grantedBy': a.grantedBy,
        }).toList(),
      }).toList();
      await prefs.setString(_usersKey, json.encode(list));
    } catch (_) {}
  }

  // ─── Compte apprenant de test (si aucun compte n'existe) ─────

  void _ensureTestAccount() {
    final hasTest = _registeredUsers.any((u) => u.email == 'apprenant@test.fr');
    if (!hasTest) {
      _registeredUsers.add(PlatformUser(
        id: 'test_student_001',
        name: 'Apprenant Test',
        email: 'apprenant@test.fr',
        passwordHash: 'test1234',
        role: UserRole.student,
        gameAccesses: [
          GameAccess(
            gameId: 'nexova',
            status: AccessStatus.granted,
            grantedBy: 'system',
          ),
          GameAccess(
            gameId: 'clarity_zone',
            status: AccessStatus.granted,
            grantedBy: 'system',
          ),
        ],
      ));
      _saveUsers();
    }
  }

  // ─── Getters ───
  PlatformUser? get currentUser => _currentUser;
  String? get activeRole => _activeRole;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isProfessor => _activeRole == 'professor';
  bool get isStudent => _activeRole == 'student';

  List<GameInfo> get allGames => GamesData.catalog;
  List<GameInfo> get publishedGames => GamesData.published;
  List<GameInfo> get comingSoonGames => GamesData.comingSoon;

  List<GameSession> get sessions => _sessions;
  List<StudentResult> get allResults => _allResults;

  // ─── Liste des apprenants inscrits ───
  List<PlatformUser> get registeredLearners =>
      _registeredUsers.where((u) => u.role == UserRole.student).toList();

  // ─── Vérifier accès apprenant courant ───
  bool currentUserHasAccess(String gameId) {
    if (_currentUser == null) return false;
    return _currentUser!.hasAccessTo(gameId);
  }

  // ─── Statistiques formateur ───
  ProfessorStats get professorStats {
    final uniqueGames =
        _sessions.map((s) => s.gameId).toSet().length;
    final totalStudents =
        _sessions.fold<int>(0, (sum, s) => sum + s.results.length);
    final allScores = _allResults.map((r) => r.percentage).toList();
    final avg = allScores.isEmpty
        ? 0.0
        : allScores.reduce((a, b) => a + b) / allScores.length;

    // Stats par jeu
    final gameStatsMap = <String, _TempStat>{};
    for (final session in _sessions) {
      final game = GamesData.getById(session.gameId);
      if (game == null) continue;
      final stat = gameStatsMap.putIfAbsent(
        session.gameId,
        () => _TempStat(game.title, game.color),
      );
      stat.sessions++;
      stat.students += session.results.length;
      for (final r in session.results) {
        stat.scores.add(r.percentage);
      }
    }

    final gameStats = gameStatsMap.entries.map((e) {
      final avg2 = e.value.scores.isEmpty
          ? 0.0
          : e.value.scores.reduce((a, b) => a + b) / e.value.scores.length;
      return GameStat(
        gameTitle: e.value.title,
        sessionCount: e.value.sessions,
        studentCount: e.value.students,
        avgScore: avg2,
        color: e.value.color,
      );
    }).toList();

    return ProfessorStats(
      totalGames: uniqueGames,
      totalSessions: _sessions.length,
      totalStudents: totalStudents,
      avgScore: avg,
      gameStats: gameStats,
    );
  }

  // ─── Connexion Formateur/Coach ───
  Future<bool> loginAsProfessor(String name) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = PlatformUser(
      id: 'prof_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@mxc-formations.fr',
      role: UserRole.professor,
    );
    _activeRole = 'professor';
    _isLoading = false;

    // Charger des données de démo
    _loadDemoData();

    notifyListeners();
    return true;
  }

  // ─── Connexion email/mdp ───
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    final existing = _registeredUsers
        .where((u) => u.email.toLowerCase() == email.toLowerCase())
        .toList();
    if (existing.isEmpty || existing.first.passwordHash != password) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    _currentUser = existing.first;
    _activeRole = 'student';
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Inscription email/mdp ───
  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));

    // Vérifier si email déjà utilisé
    final exists = _registeredUsers
        .any((u) => u.email.toLowerCase() == email.toLowerCase());
    if (exists) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = PlatformUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      passwordHash: password, // En prod : Firebase Auth / bcrypt
      role: UserRole.student,
    );
    _registeredUsers.add(newUser);
    _currentUser = newUser;
    _activeRole = 'student';
    _isLoading = false;
    await _saveUsers();
    notifyListeners();
    return true;
  }

  // ─── Donner accès à un jeu (formateur) ───
  void grantAccess(String userId, String gameId) {
    final idx = _registeredUsers.indexWhere((u) => u.id == userId);
    if (idx == -1) return;
    final user = _registeredUsers[idx];
    // Éviter les doublons
    if (user.hasAccessTo(gameId)) return;
    final newAccesses = List<GameAccess>.from(user.gameAccesses)
      ..add(GameAccess(
        gameId: gameId,
        status: AccessStatus.granted,
        grantedBy: _currentUser?.id ?? 'formateur',
      ));
    _registeredUsers[idx] = user.copyWith(gameAccesses: newAccesses);

    // Si c'est l'utilisateur courant, mettre à jour
    if (_currentUser?.id == userId) {
      _currentUser = _registeredUsers[idx];
    }
    notifyListeners();
  }

  // ─── Révoquer accès (formateur) ───
  void revokeAccess(String userId, String gameId) {
    final idx = _registeredUsers.indexWhere((u) => u.id == userId);
    if (idx == -1) return;
    final user = _registeredUsers[idx];
    final newAccesses = user.gameAccesses
        .where((a) => a.gameId != gameId)
        .toList();
    _registeredUsers[idx] = user.copyWith(gameAccesses: newAccesses);

    // Si c'est l'utilisateur courant, mettre à jour
    if (_currentUser?.id == userId) {
      _currentUser = _registeredUsers[idx];
    }
    notifyListeners();
  }

  // ─── Simuler un achat Stripe (en prod: webhook Stripe) ───
  Future<bool> simulatePurchase(String gameId) async {
    if (_currentUser == null) return false;
    _isLoading = true;
    notifyListeners();

    // Simulation d'un appel Stripe (2 secondes)
    await Future.delayed(const Duration(seconds: 2));

    final idx = _registeredUsers.indexWhere((u) => u.id == _currentUser!.id);
    if (idx == -1) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final user = _registeredUsers[idx];
    if (user.hasAccessTo(gameId)) {
      _isLoading = false;
      notifyListeners();
      return true; // Déjà acheté
    }

    final newAccesses = List<GameAccess>.from(user.gameAccesses)
      ..add(GameAccess(
        gameId: gameId,
        status: AccessStatus.purchased,
        grantedBy: 'purchase',
      ));
    _registeredUsers[idx] = user.copyWith(gameAccesses: newAccesses);
    _currentUser = _registeredUsers[idx];

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Déconnexion ───
  void logout() {
    _currentUser = null;
    _activeRole = null;
    notifyListeners();
  }

  // ─── Créer une session ───
  GameSession createSession(String gameId) {
    final code = _generateCode();
    final session = GameSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      gameId: gameId,
      sessionCode: code,
      professorId: _currentUser?.id ?? '',
      professorName: _currentUser?.name ?? 'Formateur',
      startTime: DateTime.now(),
      results: [],
    );
    _sessions.insert(0, session);
    _activeSessionCode = code;
    notifyListeners();
    return session;
  }

  String? get activeSessionCode => _activeSessionCode;

  // ─── Enregistrer un résultat de partie ───
  void saveResult(StudentResult result) {
    _allResults.add(result);
    if (_sessions.isNotEmpty && _sessions.first.isActive) {
      final updatedResults = List<StudentResult>.from(_sessions.first.results)
        ..add(result);
      _sessions[0] = GameSession(
        id: _sessions.first.id,
        gameId: _sessions.first.gameId,
        sessionCode: _sessions.first.sessionCode,
        professorId: _sessions.first.professorId,
        professorName: _sessions.first.professorName,
        startTime: _sessions.first.startTime,
        results: updatedResults,
        isActive: _sessions.first.isActive,
      );
    }
    notifyListeners();
  }

  // ─── Terminer une session ───
  void endSession(String sessionId) {
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx != -1) {
      _sessions[idx].isActive = false;
      _sessions[idx].endTime = DateTime.now();
      if (_activeSessionCode == _sessions[idx].sessionCode) {
        _activeSessionCode = null;
      }
      notifyListeners();
    }
  }

  // ─── Données de démo ───
  void _loadDemoData() {
    final rng = Random();
    final studentNames = [
      'Alice Martin', 'Baptiste Dupont', 'Clara Bernard', 'David Moreau',
      'Emma Leroy', 'François Petit', 'Gaëlle Simon', 'Hugo Laurent',
      'Inès Thomas', 'Jules Richard', 'Karen Dubois', 'Lucas Garcia',
    ];

    // Créer des apprenants démo avec accès NEXOVA
    if (_registeredUsers.isEmpty) {
      for (int i = 0; i < studentNames.length; i++) {
        final name = studentNames[i];
        final email = '${name.toLowerCase().replaceAll(' ', '.')}@demo.fr';
        final hasAccess = i < 8; // Les 8 premiers ont accès
        _registeredUsers.add(PlatformUser(
          id: 'demo_user_$i',
          name: name,
          email: email,
          passwordHash: 'demo123',
          role: UserRole.student,
          gameAccesses: hasAccess
              ? [
                  GameAccess(
                    gameId: 'nexova',
                    status: AccessStatus.granted,
                    grantedBy: 'formateur',
                  )
                ]
              : [],
        ));
      }
    }

    // Sessions pour NEXOVA
    final session1 = GameSession(
      id: 'demo_session_1',
      gameId: 'nexova',
      sessionCode: '483920',
      professorId: _currentUser?.id ?? '',
      professorName: _currentUser?.name ?? '',
      startTime: DateTime.now().subtract(const Duration(days: 7)),
      endTime: DateTime.now().subtract(const Duration(days: 7, hours: -3)),
      isActive: false,
      results: List.generate(
        8,
        (i) {
          final correct = 8 + rng.nextInt(7);
          return StudentResult(
            studentName: studentNames[i],
            score: (correct * 100),
            totalQuestions: 15,
            correctAnswers: correct,
            timeSeconds: 3200 + rng.nextInt(3600),
            completedAt: DateTime.now().subtract(Duration(days: 7, hours: -i)),
          );
        },
      ),
    );

    final session2 = GameSession(
      id: 'demo_session_2',
      gameId: 'nexova',
      sessionCode: '751234',
      professorId: _currentUser?.id ?? '',
      professorName: _currentUser?.name ?? '',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      isActive: true,
      results: List.generate(
        5,
        (i) {
          final correct = 10 + rng.nextInt(5);
          return StudentResult(
            studentName: studentNames[i + 4],
            score: (correct * 100),
            totalQuestions: 15,
            correctAnswers: correct,
            timeSeconds: 2800 + rng.nextInt(2400),
            completedAt: DateTime.now().subtract(Duration(days: 2, hours: -i)),
          );
        },
      ),
    );

    _sessions = [session2, session1];
    _allResults.clear();
    for (final s in _sessions) {
      _allResults.addAll(s.results);
    }
  }

  // ─── Helper ───
  String _generateCode() {
    final rng = Random();
    return List.generate(6, (_) => rng.nextInt(10)).join();
  }
}

class _TempStat {
  final String title;
  final dynamic color;
  int sessions = 0;
  int students = 0;
  List<double> scores = [];

  _TempStat(this.title, this.color);
}
