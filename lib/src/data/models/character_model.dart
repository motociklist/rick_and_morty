class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.type,
    required this.originName,
    required this.locationName,
    required this.episodeCount,
    required this.image,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String type;
  final String originName;
  final String locationName;
  final int episodeCount;
  final String image;

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    final rawLocation = json['location'];
    final location = rawLocation is Map
        ? Map<String, dynamic>.from(rawLocation)
        : <String, dynamic>{};
    final rawOrigin = json['origin'];
    final origin = rawOrigin is Map
        ? Map<String, dynamic>.from(rawOrigin)
        : <String, dynamic>{};
    final episodes = json['episode'];
    final episodeCount = episodes is List ? episodes.length : 0;
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      status: json['status'] as String? ?? 'Unknown',
      species: json['species'] as String? ?? 'Unknown',
      gender: json['gender'] as String? ?? 'Unknown',
      type: json['type'] as String? ?? '',
      originName: origin['name'] as String? ?? 'Unknown',
      locationName: location['name'] as String? ?? 'Unknown',
      episodeCount: episodeCount,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'type': type,
      'origin': {'name': originName},
      'location': {'name': locationName},
      'episode': List<String>.filled(episodeCount, ''),
      'image': image,
    };
  }
}
