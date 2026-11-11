import 'package:flutter/material.dart';

import 'impacto_screen.dart';
import 'lista_caronas_screen.dart';

// Casca do app: troca entre a lista de caronas e a tela de impacto pela
// barra de navegação inferior. É a navegação entre telas que a OAT exige
// (a terceira tela, "Nova carona", é aberta por cima com Navigator.push).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _abaAtual = 0;

  static const _telas = [
    ListaCaronasScreen(),
    ImpactoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _abaAtual, children: _telas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: (index) => setState(() => _abaAtual = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            activeIcon: Icon(Icons.directions_car),
            label: 'Caronas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined),
            activeIcon: Icon(Icons.eco),
            label: 'Impacto',
          ),
        ],
      ),
    );
  }
}
