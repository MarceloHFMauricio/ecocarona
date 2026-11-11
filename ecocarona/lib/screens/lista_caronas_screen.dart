import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../branding/eco_carona_logo.dart';
import '../models/carona.dart';
import '../services/carona_store.dart';
import '../widgets/carona_card.dart';
import '../widgets/empty_state.dart';
import 'nova_carona_screen.dart';

enum _Filtro { todas, agendadas, concluidas }

// Tela principal do app: a lista de caronas ligada ao problema escolhido
// (carona solidária entre colegas). Permite adicionar (FAB -> segunda
// tela), concluir e remover — os três requisitos centrais da OAT.
class ListaCaronasScreen extends StatefulWidget {
  const ListaCaronasScreen({super.key});

  @override
  State<ListaCaronasScreen> createState() => _ListaCaronasScreenState();
}

class _ListaCaronasScreenState extends State<ListaCaronasScreen> {
  _Filtro _filtro = _Filtro.todas;

  List<Carona> _aplicarFiltro(List<Carona> caronas) {
    switch (_filtro) {
      case _Filtro.agendadas:
        return caronas.where((c) => !c.concluida).toList();
      case _Filtro.concluidas:
        return caronas.where((c) => c.concluida).toList();
      case _Filtro.todas:
        return caronas;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CaronaStore>();

    if (store.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    final todas = [...store.caronas]
      ..sort((a, b) => a.dataHora.compareTo(b.dataHora));
    final visiveis = _aplicarFiltro(todas);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            EcoCaronaLogo(size: 32),
            SizedBox(width: 10),
            Text('EcoCarona'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: _FiltroChips(
              filtro: _filtro,
              onSelecionado: (novo) => setState(() => _filtro = novo),
            ),
          ),
          Expanded(
            child: visiveis.isEmpty
                ? EmptyState(
                    icone: Icons.directions_car_filled_outlined,
                    titulo: todas.isEmpty
                        ? 'Nenhuma carona cadastrada ainda'
                        : 'Nenhuma carona nesse filtro',
                    descricao: todas.isEmpty
                        ? 'Toque no botão + para combinar a primeira carona com um colega.'
                        : 'Troque o filtro acima ou cadastre uma nova carona.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    itemCount: visiveis.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final carona = visiveis[index];
                      return CaronaCard(
                        carona: carona,
                        onAlternarConcluida: () =>
                            store.alternarConcluida(carona.id),
                        onRemover: () => store.remover(carona.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NovaCaronaScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nova carona'),
      ),
    );
  }
}

class _FiltroChips extends StatelessWidget {
  const _FiltroChips({required this.filtro, required this.onSelecionado});

  final _Filtro filtro;
  final ValueChanged<_Filtro> onSelecionado;

  @override
  Widget build(BuildContext context) {
    final opcoes = {
      _Filtro.todas: 'Todas',
      _Filtro.agendadas: 'Agendadas',
      _Filtro.concluidas: 'Concluídas',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: opcoes.entries.map((entrada) {
          final selecionado = entrada.key == filtro;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entrada.value),
              selected: selecionado,
              onSelected: (_) => onSelecionado(entrada.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}
