import '../models/carona.dart';

// Fatores usados pra transformar "km rodados numa carona compartilhada"
// em algo concreto: kg de CO2 que deixou de ser emitido e dinheiro que
// deixou de ser gasto, porque os colegas não foram cada um no seu carro.
// Valores aproximados (carro popular médio, consumo ~12km/l, gasolina
// ~R$6/l e ~0,12kg de CO2 por km rodado) — não é um laudo científico,
// é uma estimativa didática pra dar sentido ao "diferencial criativo".
class ImpactCalculator {
  static const double _co2PorKm = 0.12; // kg de CO2 por km
  static const double _custoPorKm = 0.60; // R$ por km

  // Só conta o impacto de caronas que realmente aconteceram (concluídas).
  // Cada "colega" que embarcou é um carro que deixou de rodar aquele trajeto.
  static double co2EvitadoKg(List<Carona> caronas) {
    double total = 0;
    for (final carona in caronas) {
      if (carona.concluida) {
        total += carona.distanciaKm * carona.colegas * _co2PorKm;
      }
    }
    return total;
  }

  static double economiaReais(List<Carona> caronas) {
    double total = 0;
    for (final carona in caronas) {
      if (carona.concluida) {
        total += carona.distanciaKm * carona.colegas * _custoPorKm;
      }
    }
    return total;
  }

  // Quantas caronas concluídas caem dentro da semana de "agora"
  // (considerando semana de segunda a domingo). Usado na meta semanal.
  static int concluidasNaSemana(List<Carona> caronas, DateTime agora) {
    final inicioSemana = _inicioDaSemana(agora);
    final fimSemana = inicioSemana.add(const Duration(days: 7));

    return caronas.where((carona) {
      if (!carona.concluida) return false;
      return !carona.dataHora.isBefore(inicioSemana) &&
          carona.dataHora.isBefore(fimSemana);
    }).length;
  }

  static DateTime _inicioDaSemana(DateTime data) {
    final diaSemana = data.weekday; // 1 = segunda ... 7 = domingo
    final segunda = data.subtract(Duration(days: diaSemana - 1));
    return DateTime(segunda.year, segunda.month, segunda.day);
  }
}
