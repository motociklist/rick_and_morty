import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../controllers/characters_controller.dart';
import '../controllers/favorites_controller.dart';
import '../../widgets/character_card.dart';
import '../../widgets/state_widgets.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key, required this.onOpenCharacter});

  final ValueChanged<CharacterModel> onOpenCharacter;

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.offset >= threshold) {
      ref.read(charactersProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(charactersProvider);
    final favorites = ref.watch(favoritesProvider);
    final controller = ref.read(charactersProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            children: [
              TextField(
                onChanged: controller.setQuery,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'SEARCH MULTIVERSE ENTITY...',
                  hintStyle: TextStyle(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
                  filled: true,
                  fillColor: colors.surfaceContainerHighest.withValues(
                    alpha: 0.65,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _PortalFilterChip(
                      label: 'All Entities',
                      selected: state.statusFilter == 'all',
                      onTap: () => controller.setStatusFilter('all'),
                    ),
                    const SizedBox(width: 8),
                    _PortalFilterChip(
                      label: 'Alive',
                      selected: state.statusFilter == 'alive',
                      onTap: () => controller.setStatusFilter('alive'),
                    ),
                    const SizedBox(width: 8),
                    _PortalFilterChip(
                      label: 'Dead',
                      selected: state.statusFilter == 'dead',
                      onTap: () => controller.setStatusFilter('dead'),
                    ),
                    const SizedBox(width: 8),
                    _PortalFilterChip(
                      label: 'Unknown',
                      selected: state.statusFilter == 'unknown',
                      onTap: () => controller.setStatusFilter('unknown'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.loadedFromCache) const OfflineBadge(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.loadInitial,
            child: Builder(
              builder: (context) {
                if (state.isLoadingInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null && state.characters.isEmpty) {
                  return ListView(
                    children: [
                      const SizedBox(height: 80),
                      AppEmptyState(
                        icon: Icons.wifi_off_rounded,
                        title: 'Не удалось загрузить данные',
                        subtitle: state.errorMessage!,
                      ),
                    ],
                  );
                }

                final items = state.filtered;
                if (items.isEmpty) {
                  return ListView(
                    children: const [
                      SizedBox(height: 80),
                      AppEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Ничего не найдено',
                        subtitle: 'Попробуйте изменить поисковый запрос',
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: items.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(14),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final character = items[index];
                    return CharacterCard(
                      character: character,
                      isFavorite: favorites.ids.contains(character.id),
                      onFavoriteTap: () {
                        ref.read(favoritesProvider.notifier).toggle(character);
                      },
                      onTap: () => widget.onOpenCharacter(character),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PortalFilterChip extends StatelessWidget {
  const _PortalFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.2)
              : colors.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? colors.primary.withValues(alpha: 0.6)
                : colors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: selected ? colors.primary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

