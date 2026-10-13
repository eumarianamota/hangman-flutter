import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<String> teamMembers = [
    'Mariana',
    'Mayara',
    'José Wilk',
    'Irapuam',
  ];

  @override
  Widget build(BuildContext context) {
    const paperBackground = Color(0xFFF9F6F0);
    const cardBackground = Color(0xFFFDFBF7);
    const inkColor = Color(0xFF2C3E50);
    const borderColor = Color(0xFFE0D7C6);

    return Scaffold(
      backgroundColor: paperBackground,
      appBar: AppBar(
        backgroundColor: paperBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: inkColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sobre o Projeto',
          style: TextStyle(color: inkColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.school_rounded, size: 48, color: inkColor),
                    SizedBox(height: 12),
                    Text(
                      'Universidade Estadual do Piauí\n(UESPI)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: inkColor,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Campus Alexandre Alves de Oliveira • Parnaíba',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
                    ),
                    Divider(height: 24, color: borderColor),
                    Text(
                      'Curso de Tecnologia em Sistemas de Computação',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: inkColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Disciplina: Programação para Dispositivos Móveis\nProfessor: Eyder Rios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  'Equipe de Desenvolvimento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: inkColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Column(
                  children: List.generate(teamMembers.length, (index) {
                    final memberName = teamMembers[index];
                    final isLast = index == teamMembers.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFEDE6D6),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: inkColor,
                              ),
                            ),
                          ),
                          title: Text(
                            memberName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: inkColor,
                            ),
                          ),
                          subtitle: const Text(
                            'Desenvolvedor(a) • Flutter / Dart',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                        ),
                        if (!isLast)
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: borderColor,
                          ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Jogo da Forca • 1ª Avaliação • 2026.2\n100% Offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF95A5A6),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
