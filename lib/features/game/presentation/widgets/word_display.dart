import 'package:flutter/material.dart';

import '../../../../core/utils/text_normalizer.dart';
import '../../domain/engine/game_engine.dart';

/// Componente responsivo para exibição da resposta secreta.
///
/// Implementa a estratégia anti-overflow exigida pelo RNF02:
/// - A expressão completa é decomposta em palavras individuais;
/// - Cada palavra é renderizada como uma [Row] de slots de caracteres;
/// - As palavras são agrupadas em um [Wrap], quebrando linhas suavemente
///   sem provocar erros de RenderFlex overflow em telas de qualquer tamanho;
/// - Espaços e hífens são apresentados automaticamente desde o início (RF03);
/// - Letras reveladas preservam a grafia e acentuação originais (RF06).
class WordDisplay extends StatelessWidget {
  const WordDisplay({super.key, required this.engine});

  /// Instância do motor de regras da partida.
  final GameEngine engine;

  @override
  Widget build(BuildContext context) {
    final rawAnswer = engine.currentAnswer.rawAnswer;

    // Divide a expressão completa em palavras separadas por espaço
    final words = rawAnswer.split(' ');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16.0, // Espaçamento horizontal entre palavras distintas
          runSpacing:
              12.0, // Espaçamento vertical quando uma palavra quebra de linha
          children: words
              .map((word) => _WordRow(word: word, engine: engine))
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.word, required this.engine});

  final String word;
  final GameEngine engine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(word.length, (index) {
        final char = word[index];
        final isRevealed = engine.isCharRevealed(char);
        final isLetter = TextNormalizer.isLetter(char);

        return _CharacterSlot(
          char: char,
          isRevealed: isRevealed,
          isLetter: isLetter,
        );
      }),
    );
  }
}

class _CharacterSlot extends StatelessWidget {
  const _CharacterSlot({
    required this.char,
    required this.isRevealed,
    required this.isLetter,
  });

  final String char;
  final bool isRevealed;
  final bool isLetter;

  @override
  Widget build(BuildContext context) {
    const inkColor = Color(0xFF2C3E50);

    // Caracteres estruturais não alfabéticos (ex: hífen)
    if (!isLetter) {
      return Container(
        width: 18,
        height: 38,
        alignment: Alignment.center,
        child: Text(
          char,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: inkColor,
          ),
        ),
      );
    }

    // Slots de letras alfabéticas com linha sublinhada no estilo papel
    return Container(
      width: 28,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: inkColor, width: 2.5)),
      ),
      alignment: Alignment.center,
      child: isRevealed
          ? Text(
              char,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: inkColor,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
