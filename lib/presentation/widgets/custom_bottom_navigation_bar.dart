import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(    
      
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorías'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey,
    );
  }
}
