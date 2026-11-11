import 'package:ecocarona/models/carona.dart';
import 'package:ecocarona/services/impact_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

Carona _carona({
  required double distanciaKm,
  required int colegas,
  required bool concluida,
  DateTime? dataHora,
}) {
  return Carona(
    id: 'id-$distanciaKm-$colegas',
    origem: 'Casa',
    destino: 'Faculdade',
    motorista: 'Alguém',
    dataHora: dataHora ?? DateTime(2026, 11, 10),
    distanciaKm: distanciaKm,
    colegas: colegas,
    concluida: concluida,
    criadaEm: DateTime(2026, 11, 1),
  );
}

void main() {
  group('ImpactCalculator', () {
    test('ignora caronas não concluídas no cálculo de impacto', () {
      final caronas = [
        _carona(distanciaKm: 10, colegas: 2, concluida: false),
      ];

      expect(ImpactCalculator.co2EvitadoKg(caronas), 0);
      expect(ImpactCalculator.economiaReais(caronas), 0);
    });

    test('soma CO2 evitado apenas das caronas concluídas', () {
      final caronas = [
        _carona(distanciaKm: 10, colegas: 2, concluida: true), // 10*2*0.12
        _carona(distanciaKm: 5, colegas: 1, concluida: false), // ignorada
      ];

      // 10km * 2 colegas * 0.12 kg/km = 2.4 kg
      expect(ImpactCalculator.co2EvitadoKg(caronas), closeTo(2.4, 0.001));
    });

    test('calcula economia em reais das caronas concluídas', () {
      final caronas = [
        _carona(distanciaKm: 20, colegas: 3, concluida: true),
      ];

      // 20km * 3 colegas * R$0.60/km = R$36.00
      expect(ImpactCalculator.economiaReais(caronas), closeTo(36.0, 0.001));
    });

    test('conta caronas concluídas dentro da semana atual', () {
      // 2026-11-10 é uma terça-feira; a semana vai de 09/11 (seg) a 15/11 (dom)
      final agora = DateTime(2026, 11, 12);
      final caronas = [
        _carona(
          distanciaKm: 5,
          colegas: 1,
          concluida: true,
          dataHora: DateTime(2026, 11, 10),
        ),
        _carona(
          distanciaKm: 5,
          colegas: 1,
          concluida: true,
          dataHora: DateTime(2026, 11, 1), // semana passada
        ),
        _carona(
          distanciaKm: 5,
          colegas: 1,
          concluida: false,
          dataHora: DateTime(2026, 11, 11), // não concluída
        ),
      ];

      expect(
        ImpactCalculator.concluidasNaSemana(caronas, agora),
        1,
      );
    });
  });
}
