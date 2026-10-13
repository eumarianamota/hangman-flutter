import 'package:flutter/material.dart';

import '../../../session/data/session_repository.dart';
import '../../domain/entities/answer_entry.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.isWon,
    required this.answer,
    required this.errors,
    required this.hintUsed,
    required this.onNextWord,
    required this.onExitToMenu,
  });

  final bool isWon;
  final AnswerEntry answer;
  final int errors;
  final bool hintUsed;
  final VoidCallback onNextWord;
  final VoidCallback onExitToMenu;

  static Future<void> show(
    BuildContext context, {
    required bool isWon,
    required AnswerEntry answer,
    required int errors,
    required bool hintUsed,
    required VoidCallback onNextWord,
    required VoidCallback onExitToMenu,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        isWon: isWon,
        answer: answer,
        errors: errors,
        hintUsed: hintUsed,
        onNextWord: onNextWord,
        onExitToMenu: onExitToMenu,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const paperBackground = Color(0xFFFDFBF7);
    const inkColor = Color(0xFF2C3E50);
    final themeColor = isWon
        ? const Color(0xFF27AE60)
        : const Color(0xFFE74C3C);
    final stats = SessionRepository.instance.stats;

    return AlertDialog(
      backgroundColor: paperBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: themeColor, width: 2.0),
      ),
      title: Row(
        children: [
          Icon(
            isWon
                ? Icons.emoji_events_rounded
                : Icons.sentiment_very_dissatisfied_rounded,
            color: themeColor,
            size: 32,
          ),
          const SizedBox(width: 10),
          Text(
            isWon ? 'Vitória!' : 'Fim de Jogo!',
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isWon
                  ? 'Parabéns! Você descobriu a resposta antes de ser enforcado.'
                  : 'Você atingiu o limite de erros permitidos.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFEB),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE0D7C6)),
              ),
              child: Column(
                children: [
                  const Text(
                    'RESPOSTA CORRETA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    answer.rawAnswer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: inkColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _buildInfoRow('Erros na rodada:', '$errors'),
            _buildInfoRow('Dica utilizada:', hintUsed ? 'Sim' : 'Não'),
            const Divider(height: 20, color: Color(0xFFE0D7C6)),

            _buildInfoRow('Partidas na sessão:', '${stats.totalRounds}'),
            _buildInfoRow(
              'Placar acumulado:',
              '${stats.wins}V / ${stats.losses}D (${stats.winPercentage.toStringAsFixed(0)}%)',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onExitToMenu();
          },
          child: const Text(
            'Menu Principal',
            style: TextStyle(
              color: Color(0xFF7F8C8D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: inkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onNextWord();
          },
          child: const Text('Próxima Palavra'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}
