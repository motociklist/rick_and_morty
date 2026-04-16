import 'character_model.dart';

class PagedCharacters {
  const PagedCharacters({
    required this.characters,
    required this.hasNextPage,
    this.fromCache = false,
  });

  final List<CharacterModel> characters;
  final bool hasNextPage;
  final bool fromCache;
}
