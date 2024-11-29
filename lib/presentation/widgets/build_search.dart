import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/search_results_page.dart';

class BuildSearch extends StatefulWidget {
  const BuildSearch({super.key, required this.onSearch});

  final Function(String query) onSearch; // Callback para ejecutar la búsqueda

  @override
  State<BuildSearch> createState() => _BuildSearchState();
}

class _BuildSearchState extends State<BuildSearch> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      widget.onSearch(query); // Ejecuta la búsqueda en el Home
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearch, // Filtra en tiempo real (opcional)
        onSubmitted: _handleSearch, // Redirige al presionar Enter
        decoration: InputDecoration(
          hintText: 'Buscar',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _handleSearch(_searchController.text),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
