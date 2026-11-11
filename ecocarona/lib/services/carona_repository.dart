import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/carona.dart';

// Essa classe é o "banco de dados" caseiro do app. Não tem servidor nem
// internet envolvida: tudo fica salvo no próprio celular, usando o
// SharedPreferences (que no Android guarda um arquivo simples de
// preferências do app).
//
// Como a persistência funciona aqui, resumindo:
//   1. SALVAR: a lista de objetos Carona é transformada numa lista de
//      Map (toJson) e depois numa única String de texto no formato JSON
//      (jsonEncode). Essa String é gravada sob uma chave fixa
//      ('ecocarona_caronas') usando SharedPreferences.setString.
//   2. CARREGAR: quando o app abre de novo, a gente pede pro
//      SharedPreferences a String que está guardada naquela chave,
//      decodifica o JSON de volta pra uma lista de Map (jsonDecode) e
//      reconstrói cada Carona a partir do Map (Carona.fromJson).
// Se nunca foi salvo nada (primeira vez que o app abre), a chave não
// existe ainda e a gente simplesmente devolve uma lista vazia.
class CaronaRepository {
  static const _chave = 'ecocarona_caronas';

  Future<List<Carona>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final textoSalvo = prefs.getString(_chave);

    // Nada foi salvo ainda (ex: primeira vez que o app é aberto).
    if (textoSalvo == null) return [];

    final listaDecodificada = jsonDecode(textoSalvo) as List<dynamic>;
    return listaDecodificada
        .map((item) => Carona.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvar(List<Carona> caronas) async {
    final prefs = await SharedPreferences.getInstance();
    final listaDeMapas = caronas.map((carona) => carona.toJson()).toList();
    final textoParaSalvar = jsonEncode(listaDeMapas);
    await prefs.setString(_chave, textoParaSalvar);
  }
}
