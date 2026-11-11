import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/carona_store.dart';
import '../services/impact_calculator.dart';
import '../theme/app_theme.dart';

// Tela do "diferencial criativo" da OAT: transforma as caronas
// concluídas em números concretos (CO2 evitado, dinheiro economizado),
// acompanha uma meta semanal de caronas compartilhadas e mostra uma
// dica de sustentabilidade diferente a cada dia.
class ImpactoScreen extends StatelessWidget {
  const ImpactoScreen({super.key});

  static const _metaSemanal = 3;

  static const _dicas = [
    'Combine o horário de saída com seu colega a noite anterior — evita mensagens de última hora.',
    'Divida o custo do combustível proporcionalmente à distância rodada, não só por pessoa.',
    'Prefira caronas em dias de chuva: menos carros nas ruas, menos trânsito pra todo mundo.',
    'Defina um ponto de encontro fixo perto da faculdade pra facilitar a rotina da turma.',
    'Cada carona compartilhada é um carro a menos procurando vaga de estacionamento.',
    'Avise com antecedência se não puder ir — isso ajuda o motorista a organizar os horários.',
    'Revise a pressão dos pneus do carro usado na carona: economiza combustível e emite menos CO2.',
  ];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CaronaStore>();
    final caronas = store.caronas;

    final co2 = ImpactCalculator.co2EvitadoKg(caronas);
    final economia = ImpactCalculator.economiaReais(caronas);
    final concluidasNaSemana =
        ImpactCalculator.concluidasNaSemana(caronas, DateTime.now());
    final progresso = (concluidasNaSemana / _metaSemanal).clamp(0.0, 1.0);

    final dicaDoDia = _dicas[DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays
        .remainder(_dicas.length)];

    return Scaffold(
      appBar: AppBar(title: const Text('Seu impacto')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _CartaoEstatistica(
                  icone: Icons.eco,
                  cor: AppColors.verde,
                  valor: '${co2.toStringAsFixed(1)} kg',
                  legenda: 'de CO₂ evitado',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CartaoEstatistica(
                  icone: Icons.savings,
                  cor: AppColors.laranja,
                  valor: 'R\$ ${economia.toStringAsFixed(2)}',
                  legenda: 'economizados',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meta da semana',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Compartilhar $_metaSemanal caronas',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progresso,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.tealClaro),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progresso >= 1
                        ? 'Meta batida essa semana! 🎉'
                        : '$concluidasNaSemana de $_metaSemanal caronas concluídas essa semana',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.verdeEscuro,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dica do dia',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dicaDoDia,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoEstatistica extends StatelessWidget {
  const _CartaoEstatistica({
    required this.icone,
    required this.cor,
    required this.valor,
    required this.legenda,
  });

  final IconData icone;
  final Color cor;
  final String valor;
  final String legenda;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: cor),
            ),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(legenda, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
