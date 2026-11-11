import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/carona_store.dart';

// Segunda tela do fluxo de cadastro: um formulário simples pra criar uma
// nova carona. É aberta com Navigator.push a partir da lista principal —
// é a "navegação entre telas" que a OAT pede, além da aba de Impacto.
class NovaCaronaScreen extends StatefulWidget {
  const NovaCaronaScreen({super.key});

  @override
  State<NovaCaronaScreen> createState() => _NovaCaronaScreenState();
}

class _NovaCaronaScreenState extends State<NovaCaronaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();
  final _motoristaController = TextEditingController();
  final _distanciaController = TextEditingController();

  DateTime _data = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _horario = const TimeOfDay(hour: 7, minute: 30);
  int _colegas = 1;

  @override
  void dispose() {
    _origemController.dispose();
    _destinoController.dispose();
    _motoristaController.dispose();
    _distanciaController.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (escolhida != null) setState(() => _data = escolhida);
  }

  Future<void> _escolherHorario() async {
    final escolhido = await showTimePicker(
      context: context,
      initialTime: _horario,
    );
    if (escolhido != null) setState(() => _horario = escolhido);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final dataHoraCompleta = DateTime(
      _data.year,
      _data.month,
      _data.day,
      _horario.hour,
      _horario.minute,
    );

    await context.read<CaronaStore>().adicionar(
          origem: _origemController.text.trim(),
          destino: _destinoController.text.trim(),
          motorista: _motoristaController.text.trim(),
          dataHora: dataHoraCompleta,
          distanciaKm: double.parse(_distanciaController.text.replaceAll(',', '.')),
          colegas: _colegas,
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova carona')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _origemController,
              decoration: const InputDecoration(labelText: 'Origem'),
              textCapitalization: TextCapitalization.sentences,
              validator: (valor) =>
                  (valor == null || valor.trim().isEmpty) ? 'Informe a origem' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _destinoController,
              decoration: const InputDecoration(labelText: 'Destino'),
              textCapitalization: TextCapitalization.sentences,
              validator: (valor) =>
                  (valor == null || valor.trim().isEmpty) ? 'Informe o destino' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _motoristaController,
              decoration: const InputDecoration(labelText: 'Quem dirige'),
              textCapitalization: TextCapitalization.words,
              validator: (valor) =>
                  (valor == null || valor.trim().isEmpty) ? 'Informe o motorista' : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _CampoSelecao(
                    label: 'Data',
                    valor: '${_data.day.toString().padLeft(2, '0')}/'
                        '${_data.month.toString().padLeft(2, '0')}/${_data.year}',
                    icone: Icons.calendar_today,
                    onTap: _escolherData,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CampoSelecao(
                    label: 'Horário',
                    valor: _horario.format(context),
                    icone: Icons.access_time,
                    onTap: _escolherHorario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _distanciaController,
              decoration: const InputDecoration(
                labelText: 'Distância estimada (km)',
                suffixText: 'km',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) return 'Informe a distância';
                final numero = double.tryParse(valor.replaceAll(',', '.'));
                if (numero == null || numero <= 0) return 'Distância inválida';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _SeletorColegas(
              valor: _colegas,
              onChanged: (novo) => setState(() => _colegas = novo),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar carona'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoSelecao extends StatelessWidget {
  const _CampoSelecao({
    required this.label,
    required this.valor,
    required this.icone,
    required this.onTap,
  });

  final String label;
  final String valor;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          children: [
            Icon(icone, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(valor),
          ],
        ),
      ),
    );
  }
}

class _SeletorColegas extends StatelessWidget {
  const _SeletorColegas({required this.valor, required this.onChanged});

  final int valor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Colegas que embarcam (além do motorista)',
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$valor', style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                onPressed: valor > 1 ? () => onChanged(valor - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                onPressed: valor < 6 ? () => onChanged(valor + 1) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
