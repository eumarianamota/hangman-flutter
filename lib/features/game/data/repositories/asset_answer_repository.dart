import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';
import '../../domain/entities/answer_entry.dart';

class AssetAnswerRepository {
  AssetAnswerRepository({
    this.assetPath = 'assets/data/hangman.json',
    this.bundle,
  });

  final String assetPath;

  final AssetBundle? bundle;

  List<AnswerEntry> _cachedAnswers = const [];

  List<AnswerEntry> get answers => _cachedAnswers;

  Future<List<AnswerEntry>> loadAnswers({
    String Function(String)? normalizer,
  }) async {
    final activeBundle = bundle ?? rootBundle;
    try {
      final jsonString = await activeBundle.loadString(assetPath);
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'O JSON raiz deve ser um objeto contendo a chave "entries".',
        );
      }

      final dynamic entriesJson = decoded['entries'];
      if (entriesJson is! List<dynamic>) {
        throw const FormatException(
          'A propriedade "entries" deve ser uma lista de entradas.',
        );
      }

      final parsed = entriesJson
          .map((entry) {
            if (entry is! Map<String, dynamic>) {
              throw const FormatException(
                'Cada item da lista "entries" deve ser um objeto JSON.',
              );
            }
            return AnswerEntry.fromJson(entry, normalizer: normalizer);
          })
          .toList(growable: false);

      _cachedAnswers = parsed;
      return parsed;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        Exception('Falha ao carregar respostas do asset "$assetPath": $e'),
        stackTrace,
      );
    }
  }

  List<AnswerEntry> getByCategoryAndDifficulty(
    AnswerCategory category,
    Difficulty difficulty,
  ) {
    return _cachedAnswers
        .where(
          (entry) =>
              entry.category == category && entry.difficulty == difficulty,
        )
        .toList(growable: false);
  }
}
