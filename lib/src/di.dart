import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/repositories/characters_repository.dart';
import 'services/characters_api_service.dart';
import 'services/local_storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final charactersApiProvider = Provider<CharactersApiService>((ref) {
  return CharactersApiService(ref.watch(dioProvider));
});

final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  return CharactersRepository(
    ref.watch(charactersApiProvider),
    ref.watch(localStorageProvider),
  );
});
