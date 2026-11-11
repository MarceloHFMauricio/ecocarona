# EcoCarona

App Flutter feito para a OAT de Desenvolvimento Mobile Híbrido, sobre o tema
**carona solidária entre colegas** (dentro do eixo de sustentabilidade da
atividade).

O código do app fica em [`ecocarona/`](ecocarona/).

## O problema

Muitos colegas de turma fazem o mesmo trajeto (casa ↔ faculdade) sozinhos, de
carro, em horários parecidos. Isso gera mais carros nas vias, mais gasto com
combustível e mais emissão de CO₂ — um problema de sustentabilidade do
dia a dia, não só da faculdade.

## A solução

O EcoCarona deixa a turma organizar caronas compartilhadas: qualquer colega
cadastra uma carona (origem, destino, data/horário, quem dirige e quantos
colegas vão embarcar), marca como concluída quando ela acontece, e acompanha
o impacto acumulado disso — CO₂ evitado, dinheiro economizado e uma meta
semanal de caronas compartilhadas.

## Principais telas

- **Caronas** — lista principal, com filtros (Todas / Agendadas / Concluídas),
  adicionar, concluir e remover.
- **Nova carona** — formulário para cadastrar uma carona.
- **Impacto** — o diferencial criativo: CO₂ evitado, economia em reais, meta
  semanal de caronas compartilhadas e uma dica de sustentabilidade do dia.

## Rodando o projeto

```bash
cd ecocarona
flutter pub get
flutter run
```

Para gerar o `.apk`:

```bash
cd ecocarona
flutter build apk --release
```

O arquivo fica em `ecocarona/build/app/outputs/flutter-apk/app-release.apk`.

## Documentação da entrega

A documentação completa da OAT (problema, solução, prints das telas,
explicação da persistência e instruções de instalação) está em
[`docs/`](docs/).
