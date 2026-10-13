import 'package:flutter/material.dart';

import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';

class CategoryExhaustedDialog extends StatelessWidget {
  const CategoryExhaustedDialog({
    super.key,
    required this.category,
    required this.difficulty,
    required this.onSwitchSelection,
    required this.onResetCategoryWords,
  });

  final AnswerCategory category;
  final Difficulty difficulty;
  final VoidCallback onSwitchSelection;
  final VoidCallback onResetCategoryWords;

  static Future<void> show(
    BuildContext context, {
    required AnswerCategory category,
    required Difficulty difficulty,
    required VoidCallback onSwitchSelection,
    required VoidCallback onResetCategoryWords,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CategoryExhaustedDialog(
        category: category,
        difficulty: difficulty,
        onSwitchSelection: onSwitchSelection,
        onResetCategoryWords: onResetCategoryWords,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const paperBackground = Color(0xFFFDFBF7);
    const inkColor = Color(0xFF2C3E50);
    const warningColor = Color(0xFFE67E22);

    return AlertDialog(
      backgroundColor: paperBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: Color(0xFFE0D7C6), width: 2.0),
      ),
      title: const Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: warningColor, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Palavras Esgotadas!',
              style: TextStyle(
                color: inkColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Você já jogou todas as palavras cadastradas para a categoria '
            '"${category.displayName}" no nível "${difficulty.displayName}".',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF34495E),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Para continuar, você pode escolher outro grupo ou reiniciar as palavras deste grupo (suas estatísticas gerais continuarão salvas).',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7F8C8D),
              height: 1.3,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSwitchSelection();
          },
          child: const Text(
            'Trocar Seleção',
            style: TextStyle(color: Color(0xFF7F8C8D)),
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
            onResetCategoryWords();
          },
          child: const Text('Reiniciar Deste Grupo'),
        ),
      ],
    );
  }
}
