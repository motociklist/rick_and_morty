import '../../data/models/character_model.dart';

class CharacterListState {
  const CharacterListState({
    this.characters = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadedFromCache = false,
    this.query = '',
    this.statusFilter = 'all',
    this.sortBy = CharacterSort.byName,
  });

  final List<CharacterModel> characters;
  final int page;
  final bool hasMore;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool loadedFromCache;
  final String query;
  final String statusFilter;
  final CharacterSort sortBy;

  List<CharacterModel> get filtered {
    final normalized = query.trim().toLowerCase();
    final filteredItems = characters.where((item) {
      final matchesQuery = normalized.isEmpty
          ? true
          : item.name.toLowerCase().contains(normalized);
      final matchesStatus = statusFilter == 'all'
          ? true
          : item.status.toLowerCase() == statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();

    switch (sortBy) {
      case CharacterSort.byName:
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
      case CharacterSort.byStatus:
        filteredItems.sort(
          (a, b) => a.status.compareTo(b.status) != 0
              ? a.status.compareTo(b.status)
              : a.name.compareTo(b.name),
        );
    }
    return filteredItems;
  }

  CharacterListState copyWith({
    List<CharacterModel>? characters,
    int? page,
    bool? hasMore,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    bool? loadedFromCache,
    String? query,
    String? statusFilter,
    CharacterSort? sortBy,
  }) {
    return CharacterListState(
      characters: characters ?? this.characters,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      loadedFromCache: loadedFromCache ?? this.loadedFromCache,
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum CharacterSort { byName, byStatus }
