import 'dart:math';

import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';
import '../../game/domain/entities/answer_entry.dart';

class SessionStats {
  const SessionStats({
    this.totalRounds = 0,
    this.wins = 0,
    this.losses = 0,
    this.totalErrors = 0,
    this.totalHintsUsed = 0,
  });

  final int totalRounds;
  final int wins;
  final int losses;
  final int totalErrors;
  final int totalHintsUsed;

  double get winPercentage =>
      totalRounds == 0 ? 0.0 : (wins / totalRounds) * 100;

  double get lossPercentage =>
      totalRounds == 0 ? 0.0 : (losses / totalRounds) * 100;
}

class SessionRepository {
  SessionRepository._internal();

  static final SessionRepository instance = SessionRepository._internal();

  factory SessionRepository() => instance;

  final Set<String> _playedAnswerRawStrings = <String>{};
  final Random _random = Random();

  int _totalRounds = 0;
  int _wins = 0;
  int _losses = 0;
  int _totalErrors = 0;
  int _totalHintsUsed = 0;

  SessionStats get stats => SessionStats(
    totalRounds: _totalRounds,
    wins: _wins,
    losses: _losses,
    totalErrors: _totalErrors,
    totalHintsUsed: _totalHintsUsed,
  );

  Set<String> get playedAnswers => Set.unmodifiable(_playedAnswerRawStrings);

  void recordRoundResult({
    required bool isWon,
    required int errors,
    required bool hintUsed,
  }) {
    _totalRounds++;
    if (isWon) {
      _wins++;
    } else {
      _losses++;
    }
    _totalErrors += errors;
    if (hintUsed) {
      _totalHintsUsed++;
    }
  }

  bool isAnswerPlayed(AnswerEntry entry) {
    return _playedAnswerRawStrings.contains(entry.rawAnswer);
  }

  void markAnswerAsPlayed(AnswerEntry entry) {
    _playedAnswerRawStrings.add(entry.rawAnswer);
  }

  List<AnswerEntry> getAvailableAnswers(
    List<AnswerEntry> allAnswers,
    AnswerCategory category,
    Difficulty difficulty,
  ) {
    return allAnswers
        .where((entry) {
          return entry.category == category &&
              entry.difficulty == difficulty &&
              !_playedAnswerRawStrings.contains(entry.rawAnswer);
        })
        .toList(growable: false);
  }

  AnswerEntry? getRandomAvailableAnswer(
    List<AnswerEntry> allAnswers,
    AnswerCategory category,
    Difficulty difficulty,
  ) {
    final available = getAvailableAnswers(allAnswers, category, difficulty);
    if (available.isEmpty) {
      return null;
    }
    final randomIndex = _random.nextInt(available.length);
    final chosen = available[randomIndex];
    markAnswerAsPlayed(chosen);
    return chosen;
  }

  void resetPlayedAnswersForCategory(
    AnswerCategory category,
    Difficulty difficulty,
    List<AnswerEntry> allAnswers,
  ) {
    for (final entry in allAnswers) {
      if (entry.category == category && entry.difficulty == difficulty) {
        _playedAnswerRawStrings.remove(entry.rawAnswer);
      }
    }
  }

  void resetAll() {
    _playedAnswerRawStrings.clear();
    _totalRounds = 0;
    _wins = 0;
    _losses = 0;
    _totalErrors = 0;
    _totalHintsUsed = 0;
  }
}
