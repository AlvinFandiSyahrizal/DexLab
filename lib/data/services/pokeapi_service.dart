import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pokemon_model.dart';

class PokeApiService {


  Future<List<PokemonModel>> fetchPokemonListLocal() async {
    try {

      final String jsonString = await rootBundle.loadString('assets/data/pokemon_data.json');
      final data = json.decode(jsonString);


      final results = data['pokemons'] as List;


      return results.map((pokemon) => PokemonModel.fromJson(pokemon)).toList();
    } catch (e) {
      print('Error loading local data: $e');
      throw Exception('Failed to load local Pokemon data: $e');
    }
  }


  Future<PokemonModel?> getPokemonById(int id) async {
    try {
      final allPokemon = await fetchPokemonListLocal();
      return allPokemon.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }


  Future<List<PokemonModel>> searchPokemon(String query) async {
    try {
      final allPokemon = await fetchPokemonListLocal();
      return allPokemon.where((p) =>
          p.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      return [];
    }
  }
}