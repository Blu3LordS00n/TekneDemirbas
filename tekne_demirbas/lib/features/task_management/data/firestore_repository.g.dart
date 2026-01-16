// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ===============================
/// PROVIDERS (READ ONLY)
/// ===============================

@ProviderFor(firestoreRepository)
final firestoreRepositoryProvider = FirestoreRepositoryProvider._();

/// ===============================
/// PROVIDERS (READ ONLY)
/// ===============================

final class FirestoreRepositoryProvider
    extends
        $FunctionalProvider<
          FirestoreRepository,
          FirestoreRepository,
          FirestoreRepository
        >
    with $Provider<FirestoreRepository> {
  /// ===============================
  /// PROVIDERS (READ ONLY)
  /// ===============================
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
final loadTasksProvider = LoadTasksFamily._();

final class LoadTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadTasksProvider._({
    required LoadTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadTasksHash();

  @override
  String toString() {
    return r'loadTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return loadTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadTasksHash() => r'a6212b44711f2549940adad0fabeab495a20d106';

final class LoadTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  LoadTasksFamily._()
    : super(
        retry: null,
        name: r'loadTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadTasksProvider call(String roomId) =>
      LoadTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadTasksProvider';
}

@ProviderFor(loadCompletedTasks)
final loadCompletedTasksProvider = LoadCompletedTasksFamily._();

final class LoadCompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadCompletedTasksProvider._({
    required LoadCompletedTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadCompletedTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadCompletedTasksHash();

  @override
  String toString() {
    return r'loadCompletedTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return loadCompletedTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadCompletedTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadCompletedTasksHash() =>
    r'16b4f8411bd46553b16bb5ba2b264d3a6c6d024f';

final class LoadCompletedTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  LoadCompletedTasksFamily._()
    : super(
        retry: null,
        name: r'loadCompletedTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadCompletedTasksProvider call(String roomId) =>
      LoadCompletedTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadCompletedTasksProvider';
}

@ProviderFor(loadIncompletedTasks)
final loadIncompletedTasksProvider = LoadIncompletedTasksFamily._();

final class LoadIncompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  LoadIncompletedTasksProvider._({
    required LoadIncompletedTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadIncompletedTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadIncompletedTasksHash();

  @override
  String toString() {
    return r'loadIncompletedTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return loadIncompletedTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadIncompletedTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadIncompletedTasksHash() =>
    r'8fd314128fefea993a16d4943862efe13b06041b';

final class LoadIncompletedTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  LoadIncompletedTasksFamily._()
    : super(
        retry: null,
        name: r'loadIncompletedTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadIncompletedTasksProvider call(String roomId) =>
      LoadIncompletedTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadIncompletedTasksProvider';
}

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

String _$taskTypesHash() => r'7a6d7d27cb774a303aee7f05c4b506d5190c6282';

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

String _$boatTypesHash() => r'f26526e72ec68e377d1b70774fee2667cbb187d8';

/// ===============================
/// FILTERED TASKS (CLIENT SIDE)
/// ===============================

@ProviderFor(filteredTasks)
final filteredTasksProvider = FilteredTasksFamily._();

/// ===============================
/// FILTERED TASKS (CLIENT SIDE)
/// ===============================

final class FilteredTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// ===============================
  /// FILTERED TASKS (CLIENT SIDE)
  /// ===============================
  FilteredTasksProvider._({
    required FilteredTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredTasksHash();

  @override
  String toString() {
    return r'filteredTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return filteredTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredTasksHash() => r'15e0149b1c80a61dfe492af4308c5ee8838c905c';

/// ===============================
/// FILTERED TASKS (CLIENT SIDE)
/// ===============================

final class FilteredTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  FilteredTasksFamily._()
    : super(
        retry: null,
        name: r'filteredTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ===============================
  /// FILTERED TASKS (CLIENT SIDE)
  /// ===============================

  FilteredTasksProvider call(String roomId) =>
      FilteredTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'filteredTasksProvider';
}

@ProviderFor(filteredCompletedTasks)
final filteredCompletedTasksProvider = FilteredCompletedTasksFamily._();

final class FilteredCompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  FilteredCompletedTasksProvider._({
    required FilteredCompletedTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredCompletedTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredCompletedTasksHash();

  @override
  String toString() {
    return r'filteredCompletedTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return filteredCompletedTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredCompletedTasksProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredCompletedTasksHash() =>
    r'43a81491ed41b098bba5d6557499f2deac9fb3b7';

final class FilteredCompletedTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  FilteredCompletedTasksFamily._()
    : super(
        retry: null,
        name: r'filteredCompletedTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredCompletedTasksProvider call(String roomId) =>
      FilteredCompletedTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'filteredCompletedTasksProvider';
}

@ProviderFor(filteredIncompletedTasks)
final filteredIncompletedTasksProvider = FilteredIncompletedTasksFamily._();

final class FilteredIncompletedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  FilteredIncompletedTasksProvider._({
    required FilteredIncompletedTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredIncompletedTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredIncompletedTasksHash();

  @override
  String toString() {
    return r'filteredIncompletedTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return filteredIncompletedTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredIncompletedTasksProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredIncompletedTasksHash() =>
    r'd174582f99dd190c13f359978327f60d7bf505b7';

final class FilteredIncompletedTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  FilteredIncompletedTasksFamily._()
    : super(
        retry: null,
        name: r'filteredIncompletedTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredIncompletedTasksProvider call(String roomId) =>
      FilteredIncompletedTasksProvider._(argument: roomId, from: this);

  @override
  String toString() => r'filteredIncompletedTasksProvider';
}
