import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/carona.dart';
import 'carona_repository.dart';

// É aqui que a lista de caronas vive enquanto o app está aberto.
// As telas não falam direto com o CaronaRepository: elas pedem pro
// CaronaStore (adicionar, concluir, remover) e ele decide quando
// salvar de novo. Qualquer tela que "escuta" este Store (via Provider)
// é redesenhada automaticamente quando a lista muda (notifyListeners).
class CaronaStore extends ChangeNotifier {
  CaronaStore({CaronaRepository? repository})
      : _repository = repository ?? CaronaRepository();

  final CaronaRepository _repository;
  final _uuid = const Uuid();

  List<Carona> _caronas = [];
  bool _carregando = true;

  List<Carona> get caronas => List.unmodifiable(_caronas);
  bool get carregando => _carregando;

  // Chamado uma vez, quando o app abre: busca no armazenamento local o
  // que já tinha sido salvo em uma sessão anterior.
  Future<void> carregarDoDisco() async {
    _caronas = await _repository.carregar();
    _carregando = false;
    notifyListeners();
  }

  Future<void> adicionar({
    required String origem,
    required String destino,
    required String motorista,
    required DateTime dataHora,
    required double distanciaKm,
    required int colegas,
  }) async {
    final novaCarona = Carona(
      id: _uuid.v4(),
      origem: origem,
      destino: destino,
      motorista: motorista,
      dataHora: dataHora,
      distanciaKm: distanciaKm,
      colegas: colegas,
      criadaEm: DateTime.now(),
    );

    _caronas = [..._caronas, novaCarona];
    await _persistirEAvisar();
  }

  Future<void> alternarConcluida(String id) async {
    _caronas = _caronas
        .map(
          (carona) => carona.id == id
              ? carona.copyWith(concluida: !carona.concluida)
              : carona,
        )
        .toList();
    await _persistirEAvisar();
  }

  Future<void> remover(String id) async {
    _caronas = _caronas.where((carona) => carona.id != id).toList();
    await _persistirEAvisar();
  }

  // Toda vez que a lista muda (adicionar, concluir ou remover), salva a
  // versão nova inteira no SharedPreferences e avisa as telas.
  Future<void> _persistirEAvisar() async {
    notifyListeners();
    await _repository.salvar(_caronas);
  }
}
