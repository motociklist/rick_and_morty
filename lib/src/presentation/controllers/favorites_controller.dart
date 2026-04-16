import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../../di.dart';
import 'favorites_state.dart';

class FavoritesController extends StateNotifier<FavoritesState> {
  FavoritesController(this._ref) : super(FavoritesState.empty) {
    _load();
  }

  final Ref _ref;

  void _load() {
    final repository = _ref.read(charactersRepositoryProvider);
    state = FavoritesState(
      ids: repository.loadFavoriteIds(),
      characters: repository.loadFavoriteCharacters(),
    );
  }

  Future<void> toggle(CharacterModel character) async {
    final updatedIds = Set<int>.from(state.ids);
    final updatedCharacters = Map<int, CharacterModel>.from(state.characters);

    if (!updatedIds.add(character.id)) {
      updatedIds.remove(character.id);
      updatedCharacters.remove(character.id);
    } else {
      updatedCharacters[character.id] = character;
    }

    state = FavoritesState(ids: updatedIds, characters: updatedCharacters);
    final repository = _ref.read(charactersRepositoryProvider);
    await repository.saveFavoriteIds(updatedIds);
    await repository.saveFavoriteCharacters(updatedCharacters);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesController, FavoritesState>((ref) {
      return FavoritesController(ref);
    });
