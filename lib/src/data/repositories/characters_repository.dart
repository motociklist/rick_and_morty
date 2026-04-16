import 'package:dio/dio.dart';

import '../models/character_model.dart';
import '../models/paged_characters.dart';
import '../../services/characters_api_service.dart';
import '../../services/local_storage_service.dart';

class CharactersRepository {
  CharactersRepository(this._apiService, this._storage);

  final CharactersApiService _apiService;
  final LocalStorageService _storage;

  Future<PagedCharacters> getCharactersPage(int page) async {
    try {
      final response = await _apiService.fetchCharacters(page: page);
      await _savePageToCache(page, response);
      return response;
    } on DioException {
      final cached = _loadPageFromCache(page);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Future<void> _savePageToCache(int page, PagedCharacters response) async {
    final serialized = response.characters
        .map((character) => character.toJson())
        .toList();
    await _storage.pagesBox.put('page_$page', serialized);
    await _storage.pagesBox.put('has_next_$page', response.hasNextPage);
  }

  PagedCharacters? _loadPageFromCache(int page) {
    final rawCharacters = _storage.pagesBox.get('page_$page');
    if (rawCharacters is! List) {
      return null;
    }
    final characters = rawCharacters
        .whereType<Map>()
        .map((item) => CharacterModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    final hasNext = _storage.pagesBox.get('has_next_$page');
    return PagedCharacters(
      characters: characters,
      hasNextPage: hasNext == true,
      fromCache: true,
    );
  }

  Set<int> loadFavoriteIds() {
    final value = _storage.favoritesBox.get('ids');
    if (value is! List) {
      return <int>{};
    }
    return value.whereType<int>().toSet();
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    await _storage.favoritesBox.put('ids', ids.toList());
  }

  Map<int, CharacterModel> loadFavoriteCharacters() {
    final value = _storage.favoritesBox.get('characters');
    if (value is! List) {
      return <int, CharacterModel>{};
    }

    final models = value
        .whereType<Map>()
        .map((item) => CharacterModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return {for (final model in models) model.id: model};
  }

  Future<void> saveFavoriteCharacters(Map<int, CharacterModel> items) async {
    final serialized = items.values.map((item) => item.toJson()).toList();
    await _storage.favoritesBox.put('characters', serialized);
  }
}
