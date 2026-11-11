import 'package:ecocarona/models/carona.dart';
import 'package:ecocarona/services/carona_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Zera o "disco" simulado do SharedPreferences antes de cada teste,
  // pra um teste não enxergar o que o outro salvou.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CaronaRepository', () {
    test('começa vazio quando nunca foi salvo nada', () async {
      final repo = CaronaRepository();
      final caronas = await repo.carregar();
      expect(caronas, isEmpty);
    });

    test('o que é salvo pode ser carregado de volta igual', () async {
      final repo = CaronaRepository();
      final original = [
        Carona(
          id: '1',
          origem: 'Casa',
          destino: 'Faculdade',
          motorista: 'Ana',
          dataHora: DateTime(2026, 11, 10, 7, 30),
          distanciaKm: 8.5,
          colegas: 2,
          concluida: false,
          criadaEm: DateTime(2026, 11, 1),
        ),
      ];

      await repo.salvar(original);

      // Simula o app fechando e abrindo de novo: cria outra instância
      // do repositório e manda carregar os dados do zero.
      final outraInstancia = CaronaRepository();
      final carregado = await outraInstancia.carregar();

      expect(carregado.length, 1);
      expect(carregado.first.origem, 'Casa');
      expect(carregado.first.destino, 'Faculdade');
      expect(carregado.first.distanciaKm, 8.5);
      expect(carregado.first.colegas, 2);
    });
  });
}
