import 'package:flutter/material.dart';

/// Componente gráfico progressivo responsável por renderizar a forca e as
/// partes anatômicas do boneco conforme a quantidade de erros (0 a 6).
///
/// Atende estritamente ao RF08:
/// - Estado 0: Forca montada vazia (0 erros)
/// - Estado 1: Cabeça (1 erro)
/// - Estado 2: Tronco (2 erros)
/// - Estado 3: Braço esquerdo (3 erros)
/// - Estado 4: Braço direito (4 erros)
/// - Estado 5: Perna esquerda (5 erros)
/// - Estado 6: Perna direita — Enforcado completo (6 erros)
class HangmanDisplay extends StatelessWidget {
  const HangmanDisplay({
    super.key,
    required this.errorCount,
    this.size = const Size(200, 200),
  });

  /// Quantidade atual de erros cometidos na rodada (0 a 6).
  final int errorCount;

  /// Dimensão visual do componente gráfico.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0D7C6), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: CustomPaint(
        size: size,
        painter: _HangmanPainter(errorCount: errorCount),
      ),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  _HangmanPainter({required this.errorCount});

  final int errorCount;

  @override
  void paint(Canvas canvas, Size size) {
    // Tinta para a estrutura de madeira da forca
    final gallowsPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Tinta para a corda
    final ropePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Tinta para o boneco (estilo traço de caneta escura)
    final bodyPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // 1. Base horizontal da forca
    canvas.drawLine(
      Offset(w * 0.1, h * 0.9),
      Offset(w * 0.6, h * 0.9),
      gallowsPaint,
    );

    // 2. Poste vertical
    canvas.drawLine(
      Offset(w * 0.3, h * 0.9),
      Offset(w * 0.3, h * 0.1),
      gallowsPaint,
    );

    // 3. Viga superior horizontal
    canvas.drawLine(
      Offset(w * 0.3, h * 0.1),
      Offset(w * 0.75, h * 0.1),
      gallowsPaint,
    );

    // 4. Suporte diagonal da viga
    canvas.drawLine(
      Offset(w * 0.3, h * 0.25),
      Offset(w * 0.45, h * 0.1),
      gallowsPaint,
    );

    // 5. Corda descendo da ponta da viga
    final ropeTop = Offset(w * 0.75, h * 0.1);
    final ropeBottom = Offset(w * 0.75, h * 0.25);
    canvas.drawLine(ropeTop, ropeBottom, ropePaint);

    final headCenter = Offset(w * 0.75, h * 0.33);
    final headRadius = h * 0.08;

    // Erro 1: Cabeça
    if (errorCount >= 1) {
      canvas.drawCircle(headCenter, headRadius, bodyPaint);
    }

    // Erro 2: Tronco
    final neck = Offset(headCenter.dx, headCenter.dy + headRadius);
    final pelvis = Offset(headCenter.dx, h * 0.65);
    if (errorCount >= 2) {
      canvas.drawLine(neck, pelvis, bodyPaint);
    }

    // Erro 3: Braço esquerdo
    final chest = Offset(headCenter.dx, h * 0.45);
    if (errorCount >= 3) {
      canvas.drawLine(
        chest,
        Offset(headCenter.dx - (w * 0.15), h * 0.53),
        bodyPaint,
      );
    }

    // Erro 4: Braço direito
    if (errorCount >= 4) {
      canvas.drawLine(
        chest,
        Offset(headCenter.dx + (w * 0.15), h * 0.53),
        bodyPaint,
      );
    }

    // Erro 5: Perna esquerda
    if (errorCount >= 5) {
      canvas.drawLine(
        pelvis,
        Offset(headCenter.dx - (w * 0.13), h * 0.82),
        bodyPaint,
      );
    }

    // Erro 6: Perna direita
    if (errorCount >= 6) {
      canvas.drawLine(
        pelvis,
        Offset(headCenter.dx + (w * 0.13), h * 0.82),
        bodyPaint,
      );

      // Desenho expressivo dos olhos em 'X' quando enforcado
      final eyeSize = headRadius * 0.35;
      final leftEye = Offset(
        headCenter.dx - (headRadius * 0.4),
        headCenter.dy - (headRadius * 0.15),
      );
      final rightEye = Offset(
        headCenter.dx + (headRadius * 0.4),
        headCenter.dy - (headRadius * 0.15),
      );

      final xPaint = Paint()
        ..color = const Color(0xFFC0392B)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      _drawCross(canvas, leftEye, eyeSize, xPaint);
      _drawCross(canvas, rightEye, eyeSize, xPaint);
    }
  }

  void _drawCross(Canvas canvas, Offset center, double size, Paint paint) {
    final half = size / 2;
    canvas.drawLine(
      Offset(center.dx - half, center.dy - half),
      Offset(center.dx + half, center.dy + half),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + half, center.dy - half),
      Offset(center.dx - half, center.dy + half),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HangmanPainter oldDelegate) {
    return oldDelegate.errorCount != errorCount;
  }
}
