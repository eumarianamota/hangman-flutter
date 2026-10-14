import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<String> teamMembers = [
    'Mariana da Mota Pinho',
    'Mayara Lima Miranda',
    'José Wilk Souza Lima',
    'Irapuam Junio da Silva',
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
          'Integrantes do Trabalho',
          style: TextStyle(color: inkColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
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
                        'Sistemas de Computação',
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
        ),
      ),
    );
  }
}
