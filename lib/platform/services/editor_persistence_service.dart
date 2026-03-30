import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de persistance des modifications de l'éditeur de questions.
/// Stocke les overrides (label, explanation, consequence, isCorrect, toolTask)
/// par clé composite : "challengeId_actIndex_optionId" ou "challengeId_actIndex_task"
class EditorPersistenceService {
  static const String _prefix = 'editor_override_';

  // ── Clés ─────────────────────────────────────────────────────────────────

  static String _optionKey(
          String challengeId, int actIndex, String optionId) =>
      '${_prefix}opt_${challengeId}_${actIndex}_$optionId';

  static String _taskKey(String challengeId, int actIndex) =>
      '${_prefix}task_${challengeId}_$actIndex';

  // ── Sauvegarder une option ───────────────────────────────────────────────

  static Future<void> saveOption({
    required String challengeId,
    required int actIndex,
    required String optionId,
    required String label,
    required String explanation,
    required String consequence,
    required bool isCorrect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode({
      'label': label,
      'explanation': explanation,
      'consequence': consequence,
      'isCorrect': isCorrect,
    });
    await prefs.setString(_optionKey(challengeId, actIndex, optionId), data);
  }

  // ── Charger un override d'option ─────────────────────────────────────────

  static Future<Map<String, dynamic>?> loadOption({
    required String challengeId,
    required int actIndex,
    required String optionId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString(_optionKey(challengeId, actIndex, optionId));
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  // ── Sauvegarder une tâche (toolTask) ────────────────────────────────────

  static Future<void> saveToolTask({
    required String challengeId,
    required int actIndex,
    required String toolTask,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_taskKey(challengeId, actIndex), toolTask);
  }

  // ── Charger un override de tâche ─────────────────────────────────────────

  static Future<String?> loadToolTask({
    required String challengeId,
    required int actIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_taskKey(challengeId, actIndex));
  }

  // ── Appliquer tous les overrides sur une liste de challenges ─────────────
  /// À appeler au démarrage de l'éditeur pour restaurer les modifications.

  static Future<void> applyOverrides(
      List<dynamic> challenges) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));

    for (final key in keys) {
      try {
        if (key.contains('_opt_')) {
          // Format : editor_override_opt_challengeId_actIndex_optionId
          final parts = key.replaceFirst('${_prefix}opt_', '').split('_');
          if (parts.length < 3) continue;
          final challengeId = parts[0];
          final actIndex = int.tryParse(parts[1]);
          final optionId = parts.sublist(2).join('_');
          if (actIndex == null) continue;

          final raw = prefs.getString(key);
          if (raw == null) continue;
          final data = json.decode(raw) as Map<String, dynamic>;

          _applyOptionOverride(
            challenges: challenges,
            challengeId: challengeId,
            actIndex: actIndex,
            optionId: optionId,
            data: data,
          );
        } else if (key.contains('_task_')) {
          // Format : editor_override_task_challengeId_actIndex
          final parts = key.replaceFirst('${_prefix}task_', '').split('_');
          if (parts.length < 2) continue;
          final challengeId = parts[0];
          final actIndex = int.tryParse(parts[1]);
          if (actIndex == null) continue;

          final toolTask = prefs.getString(key);
          if (toolTask == null) continue;

          _applyTaskOverride(
            challenges: challenges,
            challengeId: challengeId,
            actIndex: actIndex,
            toolTask: toolTask,
          );
        }
      } catch (_) {
        // On ignore les clés malformées
      }
    }
  }

  static void _applyOptionOverride({
    required List<dynamic> challenges,
    required String challengeId,
    required int actIndex,
    required String optionId,
    required Map<String, dynamic> data,
  }) {
    for (final c in challenges) {
      if (c.id != challengeId) continue;
      final acts = c.scenario.acts;
      if (actIndex >= acts.length) continue;
      final options = List.from(acts[actIndex].options);
      for (int i = 0; i < options.length; i++) {
        if (options[i].id == optionId) {
          options[i] = options[i].copyWith(
            label: data['label'] as String?,
            explanation: data['explanation'] as String?,
            consequence: data['consequence'] as String?,
            isCorrect: data['isCorrect'] as bool?,
          );
          acts[actIndex] = acts[actIndex].copyWith(options: List.from(options));
          break;
        }
      }
      break;
    }
  }

  static void _applyTaskOverride({
    required List<dynamic> challenges,
    required String challengeId,
    required int actIndex,
    required String toolTask,
  }) {
    for (final c in challenges) {
      if (c.id != challengeId) continue;
      final acts = c.scenario.acts;
      if (actIndex >= acts.length) continue;
      acts[actIndex] = acts[actIndex].copyWith(toolTask: toolTask);
      break;
    }
  }

  // ── Effacer tous les overrides (reset) ───────────────────────────────────

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final k in keys) {
      await prefs.remove(k);
    }
  }
}
