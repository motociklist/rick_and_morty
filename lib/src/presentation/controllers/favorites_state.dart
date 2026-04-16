import '../../data/models/character_model.dart';

class FavoritesState {
  const FavoritesState({required this.ids, required this.characters});

  final Set<int> ids;
  final Map<int, CharacterModel> characters;

  static const empty = FavoritesState(
    ids: <int>{},
    characters: <int, CharacterModel>{},
  );
}
