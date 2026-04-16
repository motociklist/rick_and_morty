import 'package:dio/dio.dart';

import '../data/models/character_model.dart';
import '../data/models/paged_characters.dart';

class CharactersApiService {
  CharactersApiService(this._dio);

  final Dio _dio;

  Future<PagedCharacters> fetchCharacters({required int page}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://rickandmortyapi.com/api/character',
      queryParameters: {'page': page},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty API response');
    }

    final info = data['info'] as Map<String, dynamic>? ?? {};
    final results = data['results'] as List<dynamic>? ?? [];

    final characters = results
        .whereType<Map<String, dynamic>>()
        .map(CharacterModel.fromJson)
        .toList();

    return PagedCharacters(
      characters: characters,
      hasNextPage: info['next'] != null,
    );
  }
}
