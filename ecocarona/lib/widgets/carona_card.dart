import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/carona.dart';
import '../theme/app_theme.dart';

// Um cartão da lista principal. Mostra o trajeto, quem dirige, quando é
// e dá acesso rápido às duas ações que a OAT pede: concluir e remover.
class CaronaCard extends StatelessWidget {
  const CaronaCard({
    super.key,
    required this.carona,
    required this.onAlternarConcluida,
    required this.onRemover,
  });

  final Carona carona;
  final VoidCallback onAlternarConcluida;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat("EEE, d 'de' MMM 'às' HH:mm", 'pt_BR');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${carona.origem}  →  ${carona.destino}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: carona.concluida
                              ? TextDecoration.lineThrough
                              : null,
                          color: carona.concluida ? Colors.grey : null,
                        ),
                  ),
                ),
                _Selo(concluida: carona.concluida),
              ],
            ),
            const SizedBox(height: 8),
            _LinhaInfo(icone: Icons.person, texto: carona.motorista),
            _LinhaInfo(
              icone: Icons.schedule,
              texto: formatoData.format(carona.dataHora),
            ),
            _LinhaInfo(
              icone: Icons.route,
              texto:
                  '${carona.distanciaKm.toStringAsFixed(1)} km · ${carona.colegas} colega(s)',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onRemover,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Remover'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
                ),
                const SizedBox(width: 4),
                FilledButton.tonalIcon(
                  onPressed: onAlternarConcluida,
                  icon: Icon(
                    carona.concluida
                        ? Icons.replay
                        : Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: Text(carona.concluida ? 'Reabrir' : 'Concluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icone, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(texto, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  const _Selo({required this.concluida});

  final bool concluida;

  @override
  Widget build(BuildContext context) {
    final cor = concluida ? AppColors.verde : AppColors.laranja;
    final texto = concluida ? 'Concluída' : 'Agendada';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: cor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
