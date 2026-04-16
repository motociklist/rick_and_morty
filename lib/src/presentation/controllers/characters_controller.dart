import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../../di.dart';
import 'character_list_state.dart';

class CharactersController extends StateNotifier<CharacterListState> {
  CharactersController(this._ref) : super(const CharacterListState()) {
    loadInitial();
  }

  final Ref _ref;

  Future<void> loadInitial() async {
    state = state.copyWith(
      isLoadingInitial: true,
      clearError: true,
      page: 1,
      hasMore: true,
      characters: [],
      loadedFromCache: false,
    );
    await _loadPage(1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingInitial || state.isLoadingMore || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _loadPage(state.page + 1, replace: false);
  }

  Future<void> _loadPage(int page, {required bool replace}) async {
    try {
      final response = await _ref
          .read(charactersRepositoryProvider)
          .getCharactersPage(page);

      final current = replace ? <CharacterModel>[] : state.characters;
      final merged = _mergeWithoutDuplicates(current, response.characters);

      state = state.copyWith(
        characters: merged,
        page: page,
        hasMore: response.hasNextPage,
        isLoadingInitial: false,
        isLoadingMore: false,
        clearError: true,
        loadedFromCache: response.fromCache,
      );
    } on DioException {
      state = state.copyWith(
        isLoadingInitial: false,
        isLoadingMore: false,
        errorMessage: 'Не удалось загрузить данные. Проверьте интернет.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingInitial: false,
        isLoadingMore: false,
        errorMessage: 'Произошла непредвиденная ошибка.',
      );
    }
  }

  List<CharacterModel> _mergeWithoutDuplicates(
    List<CharacterModel> oldItems,
    List<CharacterModel> newItems,
  ) {
    final map = <int, CharacterModel>{
      for (final item in oldItems) item.id: item,
    };
    for (final item in newItems) {
      map[item.id] = item;
    }
    return map.values.toList()..sort((a, b) => a.id.compareTo(b.id));
  }

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void setStatusFilter(String value) {
    state = state.copyWith(statusFilter: value.toLowerCase());
  }

  void setSort(CharacterSort value) {
    state = state.copyWith(sortBy: value);
  }
}

final charactersProvider =
    StateNotifierProvider<CharactersController, CharacterListState>((ref) {
      return CharactersController(ref);
    });
