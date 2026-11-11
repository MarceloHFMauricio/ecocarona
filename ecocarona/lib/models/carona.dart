// Representa uma carona compartilhada entre colegas.
// Cada instância é um item da lista principal do app.
class Carona {
  final String id;
  final String origem;
  final String destino;
  final String motorista;
  final DateTime dataHora;
  final double distanciaKm;
  final int colegas; // quantos colegas embarcam além do motorista
  final bool concluida;
  final DateTime criadaEm;

  Carona({
    required this.id,
    required this.origem,
    required this.destino,
    required this.motorista,
    required this.dataHora,
    required this.distanciaKm,
    required this.colegas,
    this.concluida = false,
    required this.criadaEm,
  });

  Carona copyWith({
    String? origem,
    String? destino,
    String? motorista,
    DateTime? dataHora,
    double? distanciaKm,
    int? colegas,
    bool? concluida,
  }) {
    return Carona(
      id: id,
      origem: origem ?? this.origem,
      destino: destino ?? this.destino,
      motorista: motorista ?? this.motorista,
      dataHora: dataHora ?? this.dataHora,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      colegas: colegas ?? this.colegas,
      concluida: concluida ?? this.concluida,
      criadaEm: criadaEm,
    );
  }

  // Vira um Map simples (só tipos primitivos) pra poder transformar em
  // texto JSON e salvar no SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origem': origem,
      'destino': destino,
      'motorista': motorista,
      'dataHora': dataHora.toIso8601String(),
      'distanciaKm': distanciaKm,
      'colegas': colegas,
      'concluida': concluida,
      'criadaEm': criadaEm.toIso8601String(),
    };
  }

  // Caminho inverso: reconstrói a carona a partir do Map que veio do JSON
  // salvo. Usado quando o app abre e carrega o que já existia.
  factory Carona.fromJson(Map<String, dynamic> json) {
    return Carona(
      id: json['id'] as String,
      origem: json['origem'] as String,
      destino: json['destino'] as String,
      motorista: json['motorista'] as String,
      dataHora: DateTime.parse(json['dataHora'] as String),
      distanciaKm: (json['distanciaKm'] as num).toDouble(),
      colegas: json['colegas'] as int,
      concluida: json['concluida'] as bool,
      criadaEm: DateTime.parse(json['criadaEm'] as String),
    );
  }
}
