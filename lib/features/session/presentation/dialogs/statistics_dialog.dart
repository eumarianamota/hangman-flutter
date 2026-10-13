import 'package:flutter/material.dart';

import '../../data/session_repository.dart';

class StatisticsDialog extends StatelessWidget {
  const StatisticsDialog({super.key, this.stats});

  final SessionStats? stats;

  static Future<void> show(BuildContext context, {SessionStats? stats}) {
    return showDialog<void>(
      context: context,
      builder: (context) => StatisticsDialog(stats: stats),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStats = stats ?? SessionRepository.instance.stats;
    const inkColor = Color(0xFF2C3E50);
    const paperBackground = Color(0xFFFDFBF7);
    const borderColor = Color(0xFFE0D7C6);

    return AlertDialog(
      backgroundColor: paperBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: borderColor, width: 2.0),
      ),
      title: const Row(
        children: [
          Icon(Icons.bar_chart_rounded, color: inkColor, size: 28),
          SizedBox(width: 10),
          Text(
            'Estatísticas da Sessão',
            style: TextStyle(
              color: inkColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatTile(
              label: 'Total de Partidas',
              value: '${currentStats.totalRounds}',
              icon: Icons.sports_esports_outlined,
            ),
            const Divider(color: borderColor),
            _StatTile(
              label: 'Vitórias',
              value:
                  '${currentStats.wins} (${currentStats.winPercentage.toStringAsFixed(1)}%)',
              icon: Icons.emoji_events_outlined,
              valueColor: const Color(0xFF27AE60),
            ),
            const Divider(color: borderColor),
            _StatTile(
              label: 'Derrotas',
              value:
                  '${currentStats.losses} (${currentStats.lossPercentage.toStringAsFixed(1)}%)',
              icon: Icons.sentiment_very_dissatisfied_outlined,
              valueColor: const Color(0xFFE74C3C),
            ),
            const Divider(color: borderColor),
            _StatTile(
              label: 'Erros Cometidos',
              value: '${currentStats.totalErrors}',
              icon: Icons.close_rounded,
            ),
            const Divider(color: borderColor),
            _StatTile(
              label: 'Dicas Utilizadas',
              value: '${currentStats.totalHintsUsed}',
              icon: Icons.lightbulb_outline_rounded,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Fechar',
            style: TextStyle(
              color: inkColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    const inkColor = Color(0xFF2C3E50);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF7F8C8D)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Color(0xFF34495E)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor ?? inkColor,
            ),
          ),
        ],
      ),
    );
  }
}
