import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Marca do EcoCarona: um selo verde com uma folha (sustentabilidade) cujo
// talo se curva e se transforma numa estradinha com uma faixa pontilhada
// (a carona). É desenhada em código com CustomPainter, então não depende
// de nenhum arquivo de imagem — funciona em qualquer tamanho/resolução.
class EcoCaronaLogo extends StatelessWidget {
  const EcoCaronaLogo({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final raio = size.width / 2;

    // Selo circular com degradê verde -> teal.
    final fundo = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.verde, AppColors.tealClaro],
      ).createShader(Rect.fromCircle(center: centro, radius: raio));
    canvas.drawCircle(centro, raio, fundo);

    // Estrada: uma curva branca na parte de baixo do selo, com uma
    // faixa pontilhada central, sugerindo o trajeto da carona.
    final estrada = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round;

    final caminhoEstrada = Path()
      ..moveTo(size.width * 0.18, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.95,
        size.width * 0.86,
        size.height * 0.68,
      );
    canvas.drawPath(caminhoEstrada, estrada);

    // Folha: um "amêndoa" formada por duas curvas, com uma nervura
    // central, flutuando acima da estrada.
    final folha = Paint()..color = Colors.white;
    final caminhoFolha = Path()
      ..moveTo(size.width * 0.5, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.30,
        size.width * 0.5,
        size.height * 0.66,
      )
      ..quadraticBezierTo(
        size.width * 0.20,
        size.height * 0.30,
        size.width * 0.5,
        size.height * 0.20,
      )
      ..close();
    canvas.drawPath(caminhoFolha, folha);

    final nervura = Paint()
      ..color = AppColors.verdeEscuro.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;
    final caminhoNervura = Path()
      ..moveTo(size.width * 0.5, size.height * 0.26)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.46,
        size.width * 0.5,
        size.height * 0.60,
      );
    canvas.drawPath(caminhoNervura, nervura);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
