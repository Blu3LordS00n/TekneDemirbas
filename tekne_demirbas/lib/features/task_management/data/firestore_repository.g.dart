// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firestoreRepository)
final firestoreRepositoryProvider = FirestoreRepositoryProvider._();

final class FirestoreRepositoryProvider
    extends
        $FunctionalProvider<
          FirestoreRepository,
          FirestoreRepository,
          FirestoreRepository
        >
    with $Provider<FirestoreRepository> {
  FirestoreRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreRepositoryHash();

  @$internal
  @override
  $ProviderElement<FirestoreRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirestoreRepository create(Ref ref) {
    return firestoreRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreRepository>(value),
    );
  }
}

String _$firestoreRepositoryHash() =>
    r'95c1c445734f56d18e7408d875baf5988563dc72';

@ProviderFor(loadTasks)
final loadTasksProvider = LoadTasksProvider._();

final class LoadTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return loadTasks(ref);
  }
}

String _$loadTasksHash() => r'51f71cb73eb7de9ec681070ad9146fa90161175e';

@ProviderFor(loadCompletedTasks)
final loadCompletedTasksProvider = LoadCompletedTasksProvider._();

final class LoadCompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadCompletedTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadCompletedTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadCompletedTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return loadCompletedTasks(ref);
  }
}

String _$loadCompletedTasksHash() =>
    r'208704b423eca1c8a7a8ebe24ac7706b67aaf09a';

@ProviderFor(loadIncompletedTasks)
final loadIncompletedTasksProvider = LoadIncompletedTasksProvider._();

final class LoadIncompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadIncompletedTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadIncompletedTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadIncompletedTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return loadIncompletedTasks(ref);
  }
}

String _$loadIncompletedTasksHash() =>
    r'0136d87ab2006458e9385da9b8f138638d131b00';
