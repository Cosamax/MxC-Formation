// ============================================================
// LEGAL QUEST — Écran de jeu principal (Question)
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_theme.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 30;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final q = context.read<GameProvider>().currentQuestion;
    _seconds = q?.timeSeconds ?? 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _seconds--);
      context.read<GameProvider>().updateTimer(_seconds);
      if (_seconds <= 0) {
        t.cancel();
        context.read<GameProvider>().timeUp();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _onAnswerSelected(String answerId) {
    final game = context.read<GameProvider>();
    if (game.isAnswerLocked) return;
    _timer?.cancel();
    final q = game.currentQuestion!;
    final correct = answerId == q.correctAnswerId;
    setState(() {
      _lastAnswerCorrect = correct;
    });
    if (!correct) {
      _shakeController.forward(from: 0);
    }
    game.selectAnswer(answerId);
  }

  void _onNext() {
    final game = context.read<GameProvider>();
    game.nextQuestion();

    if (game.isGameOver) {
      Navigator.popUntil(context, (r) => r.settings.name == '/');
      return;
    }

    // If we moved to a new module, pop back to map
    if (game.currentQuestionIndex == 0 && !game.isGameOver) {
      Navigator.pop(context);
      return;
    }

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final q = game.currentQuestion;
        if (q == null) return const SizedBox();
        final mod = game.currentModule!;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppTheme.navyGradient),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(game, mod),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        children: [
                          if (game.gameMode == 'team' && game.session != null)
                            _buildTeamTurnBadge(game),
                          const SizedBox(height: 12),
                          _buildQuestionCard(q, game),
                          const SizedBox(height: 16),
                          _buildAnswerOptions(q, game),
                          if (game.showExplanation) ...[
                            const SizedBox(height: 16),
                            _buildExplanation(q, game),
                            const SizedBox(height: 16),
                            _buildNextButton(game),
                          ],
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(GameProvider game, GameModule mod) {
    final total = mod.questions.length;
    final current = game.currentQuestionIndex + 1;
    final timeRatio = _seconds / (game.currentQuestion?.timeSeconds ?? 30);
    final timeColor = timeRatio > 0.5
        ? AppTheme.success
        : timeRatio > 0.25
            ? AppTheme.warning
            : AppTheme.error;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppTheme.textMuted, size: 20),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${mod.icon} ${mod.title.toUpperCase()}',
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Question $current / $total',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: timeRatio.clamp(0.0, 1.0),
                      backgroundColor: AppTheme.navyAccent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(timeColor),
                      strokeWidth: 4,
                    ),
                  ),
                  Text(
                    '$_seconds',
                    style: TextStyle(
                      color: timeColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: game.moduleProgress,
              minHeight: 4,
              backgroundColor: AppTheme.navyAccent,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamTurnBadge(GameProvider game) {
    final team = game.currentTeam;
    if (team == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.group, color: AppTheme.gold, size: 16),
          const SizedBox(width: 8),
          Text(
            'Tour de : ${team.name}',
            style: const TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${team.score} pts',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question q, GameProvider game) {
    final difficultyColor = q.difficulty == Difficulty.easy
        ? AppTheme.success
        : q.difficulty == Difficulty.medium
            ? AppTheme.warning
            : AppTheme.error;
    final difficultyLabel = q.difficulty == Difficulty.easy
        ? 'FACILE'
        : q.difficulty == Difficulty.medium
            ? 'MOYEN'
            : 'DIFFICILE';

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (ctx, child) {
        return Transform.translate(
          offset: _lastAnswerCorrect
              ? Offset.zero
              : Offset(
                  _shakeAnim.value *
                      (_shakeController.status ==
                              AnimationStatus.forward
                          ? 1
                          : -1),
                  0),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: game.showExplanation
                ? (_lastAnswerCorrect
                    ? AppTheme.success
                    : AppTheme.error)
                : AppTheme.divider,
            width: game.showExplanation ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: difficultyColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: difficultyColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    difficultyLabel,
                    style: TextStyle(
                      color: difficultyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${q.points} pts',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.navyAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    q.ficheReference,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Type label
            if (q.type == QuestionType.scenario)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Text('🎭', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      'SCÉNARIO',
                      style: TextStyle(
                        color: AppTheme.info,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            if (q.type == QuestionType.flashChallenge)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    const Text(
                      'DÉFI FLASH',
                      style: TextStyle(
                        color: AppTheme.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              q.questionText,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question q, GameProvider game) {
    if (q.type == QuestionType.trueFalse) {
      return Row(
        children: q.answers.map((a) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildAnswerButton(a, q, game, isWide: true),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: q.answers
          .map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildAnswerButton(a, q, game),
              ))
          .toList(),
    );
  }

  Widget _buildAnswerButton(Answer answer, Question q, GameProvider game,
      {bool isWide = false}) {
    final selected = game.selectedAnswerId == answer.id;
    final locked = game.isAnswerLocked;
    final isCorrect = answer.id == q.correctAnswerId;

    Color bgColor = AppTheme.navyAccent;
    Color borderColor = AppTheme.divider;
    Color textColor = AppTheme.textLight;
    Widget? trailingIcon;

    if (locked) {
      if (isCorrect) {
        bgColor = AppTheme.success.withValues(alpha: 0.2);
        borderColor = AppTheme.success;
        textColor = AppTheme.success;
        trailingIcon =
            const Icon(Icons.check_circle, color: AppTheme.success, size: 20);
      } else if (selected && !isCorrect) {
        bgColor = AppTheme.error.withValues(alpha: 0.2);
        borderColor = AppTheme.error;
        textColor = AppTheme.error;
        trailingIcon =
            const Icon(Icons.cancel, color: AppTheme.error, size: 20);
      }
    } else if (selected) {
      bgColor = AppTheme.gold.withValues(alpha: 0.15);
      borderColor = AppTheme.gold;
      textColor = AppTheme.gold;
    }

    final labels = ['A', 'B', 'C', 'D'];
    final labelIndex = q.answers.indexOf(answer);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: locked ? null : () => _onAnswerSelected(answer.id),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: isWide
                ? const EdgeInsets.symmetric(vertical: 20, horizontal: 12)
                : const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: isWide
                ? Column(
                    children: [
                      Text(
                        answer.text,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(height: 6),
                        trailingIcon,
                      ],
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: borderColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            labelIndex >= 0 && labelIndex < labels.length
                                ? labels[labelIndex]
                                : '?',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          answer.text,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        trailingIcon,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(Question q, GameProvider game) {
    final team = game.currentTeam;
    final isCorrect = game.selectedAnswerId == q.correctAnswerId;
    final timedOut = game.selectedAnswerId == null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? AppTheme.success.withValues(alpha: 0.5)
              : AppTheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                timedOut
                    ? '⏰ TEMPS ÉCOULÉ !'
                    : isCorrect
                        ? '✅ BONNE RÉPONSE !'
                        : '❌ MAUVAISE RÉPONSE',
                style: TextStyle(
                  color: timedOut
                      ? AppTheme.warning
                      : isCorrect
                          ? AppTheme.success
                          : AppTheme.error,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              if (team != null && isCorrect)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+ ${q.points} pts',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.navyAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    q.explanation,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.book, color: AppTheme.gold, size: 14),
              const SizedBox(width: 4),
              Text(
                'Référence : ${q.ficheReference}',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Series badge
          if (team != null && team.streakCount >= 3) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                '🔥 Série de ${team.streakCount} ! +Bonus',
                style: const TextStyle(
                  color: AppTheme.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNextButton(GameProvider game) {
    final isLastQuestion =
        game.currentQuestionIndex == game.totalQuestionsInModule - 1;
    final isLastModule =
        game.currentModuleIndex == game.modules.length - 1;

    String label;
    if (isLastModule && isLastQuestion) {
      label = '🏆 VOIR LE CLASSEMENT';
    } else if (isLastQuestion) {
      label = '▶ MODULE SUIVANT';
    } else {
      label = '▶ QUESTION SUIVANTE';
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.gold,
          foregroundColor: AppTheme.navyDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
