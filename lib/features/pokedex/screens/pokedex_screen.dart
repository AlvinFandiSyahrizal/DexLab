import 'package:flutter/material.dart';
import '../../../data/models/pokemon_model.dart';
import '../../../data/services/pokeapi_service.dart';
import '../widgets/pokemon_card.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final PokeApiService api = PokeApiService();
  List<PokemonModel> pokemons = [];
  List<PokemonModel> filteredPokemons = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPokemons();
    searchController.addListener(_filterPokemons);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPokemons() async {
    try {
      final data = await api.fetchPokemonListLocal();
      setState(() {
        pokemons = data;
        filteredPokemons = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
      print('Error loading Pokemon: $e');
    }
  }

  void _filterPokemons() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPokemons = pokemons;
      } else {
        filteredPokemons = pokemons.where((pokemon) {
          return pokemon.name.toLowerCase().contains(query) ||
              pokemon.id.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Pokédex",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [

          Container(
            color: Colors.red,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Pokemon...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    searchController.clear();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),




          Expanded(
            child: isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text('Loading Pokemon...'),
                ],
              ),
            )
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load Pokemon',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      loadPokemons();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : filteredPokemons.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Pokemon found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: filteredPokemons.length,
              itemBuilder: (context, index) {
                return PokemonCard(pokemon: filteredPokemons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}