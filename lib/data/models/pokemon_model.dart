class PokemonModel {
  final int id;
  final String name;
  final String imageUrl;
  final int? height;
  final int? weight;
  final List<String>? types;
  final List<String>? abilities;
  final Map<String, dynamic>? stats;

  PokemonModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height,
    this.weight,
    this.types,
    this.abilities,
    this.stats,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      height: json['height'],
      weight: json['weight'],
      types: json['types'] != null
          ? List<String>.from(json['types'])
          : null,
      abilities: json['abilities'] != null
          ? List<String>.from(json['abilities'])
          : null,
      stats: json['stats'],
    );
  }

  // Getter untuk primary type (untuk styling)
  String get primaryType => types?.isNotEmpty == true ? types!.first : 'normal';
}