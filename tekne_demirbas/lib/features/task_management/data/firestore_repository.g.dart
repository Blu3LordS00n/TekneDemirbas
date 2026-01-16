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

@ProviderFor(filteredTasks)
final filteredTasksProvider = FilteredTasksProvider._();

final class FilteredTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  FilteredTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return filteredTasks(ref);
  }
}

String _$filteredTasksHash() => r'11f5a216ac8a5b057709f24623e90270cdf0ba5f';

@ProviderFor(filteredCompletedTasks)
final filteredCompletedTasksProvider = FilteredCompletedTasksProvider._();

final class FilteredCompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  FilteredCompletedTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCompletedTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCompletedTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return filteredCompletedTasks(ref);
  }
}

String _$filteredCompletedTasksHash() => r'22f6a316ac8a5b057709f24623e90270cdf0ba5f';

@ProviderFor(filteredIncompletedTasks)
final filteredIncompletedTasksProvider = FilteredIncompletedTasksProvider._();

final class FilteredIncompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  FilteredIncompletedTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredIncompletedTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredIncompletedTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return filteredIncompletedTasks(ref);
  }
}

String _$filteredIncompletedTasksHash() => r'33f7a416ac8a5b057709f24623e90270cdf0ba5f';

@ProviderFor(taskTypes)
final taskTypesProvider = TaskTypesProvider._();

final class TaskTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskType>>,
          List<TaskType>,
          Stream<List<TaskType>>
        >
    with $FutureModifier<List<TaskType>>, $StreamProvider<List<TaskType>> {
  TaskTypesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskTypesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskTypesHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskType>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TaskType>> create(Ref ref) {
    return taskTypes(ref);
  }
}

String _$taskTypesHash() => r'f6a0560a4330a3f5169c207173d869b3a57c0121';

@ProviderFor(boatTypes)
final boatTypesProvider = BoatTypesProvider._();

final class BoatTypesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BoatType>>,
          List<BoatType>,
          Stream<List<BoatType>>
        >
    with $FutureModifier<List<BoatType>>, $StreamProvider<List<BoatType>> {
  BoatTypesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'boatTypesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$boatTypesHash();

  @$internal
  @override
  $StreamProviderElement<List<BoatType>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BoatType>> create(Ref ref) {
    return boatTypes(ref);
  }
}

String _$boatTypesHash() => r'fc1b5f4af02ca46ad43308df8eb5443126a347e6';
