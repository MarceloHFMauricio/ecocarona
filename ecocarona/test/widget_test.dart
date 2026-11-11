// Teste de ponta a ponta simples: sobe o app de verdade (com
// SharedPreferences zerado, simulando a primeira abertura) e confere
// que a tela principal aparece sem nenhuma carona cadastrada ainda.
import 'package:ecocarona/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('abre na lista de caronas mostrando o estado vazio',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EcoCaronaApp());

    // A primeira leitura do SharedPreferences é assíncrona (Future);
    // esse pump espera ela terminar antes de olhar a tela.
    await tester.pumpAndSettle();

    expect(find.text('EcoCarona'), findsOneWidget);
    expect(find.text('Nenhuma carona cadastrada ainda'), findsOneWidget);
  });
}
