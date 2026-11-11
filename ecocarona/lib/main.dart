import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'screens/home_shell.dart';
import 'services/carona_store.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega os nomes de mês/dia da semana em português antes de usar o
  // DateFormat('pt_BR') nos cartões de carona.
  await initializeDateFormatting('pt_BR');
  runApp(const EcoCaronaApp());
}

class EcoCaronaApp extends StatelessWidget {
  const EcoCaronaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cria o Store e, assim que o app sobe, manda ele ler do disco o
      // que já tinha sido salvo numa sessão anterior.
      create: (_) => CaronaStore()..carregarDoDisco(),
      child: MaterialApp(
        title: 'EcoCarona',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeShell(),
      ),
    );
  }
}
