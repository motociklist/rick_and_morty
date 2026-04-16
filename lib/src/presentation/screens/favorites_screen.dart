import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../controllers/characters_controller.dart';
import '../controllers/favorites_controller.dart';
import '../../widgets/character_card.dart';
import '../../widgets/state_widgets.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key, required this.onOpenCharacter});

  final ValueChanged<CharacterModel> onOpenCharacter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final loadedCharacters = ref.watch(charactersProvider).characters;
    final merged = Map<int, CharacterModel>.from(favorites.characters);
    for (final item in loadedCharacters) {
      if (favorites.ids.contains(item.id)) {
        merged[item.id] = item;
      }
    }
    final favoriteCharacters = merged.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final uniqueOrigins = favoriteCharacters
        .map((item) => item.originName)
        .toSet()
        .length;

    return favoriteCharacters.isEmpty
        ? const AppEmptyState(
            icon: Icons.star_border_rounded,
            title: 'Список избранного пуст',
            subtitle: 'Добавьте персонажей из главного экрана',
          )
        : ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHigh.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBlock(
                        value: favoriteCharacters.length.toString().padLeft(
                          2,
                          '0',
                        ),
                        label: 'Captured',
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      _StatBlock(
                        value: uniqueOrigins.toString().padLeft(2, '0'),
                        label: 'Dimensions',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...favoriteCharacters.map(
                (character) => CharacterCard(
                  character: character,
                  isFavorite: true,
                  onFavoriteTap: () {
                    ref.read(favoritesProvider.notifier).toggle(character);
                  },
                  onTap: () => onOpenCharacter(character),
                ),
              ),
            ],
          );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: colors.primary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
