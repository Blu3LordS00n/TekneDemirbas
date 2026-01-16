// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskFilterController)
final taskFilterControllerProvider = TaskFilterControllerProvider._();

final class TaskFilterControllerProvider
    extends $NotifierProvider<TaskFilterController, TaskFilter> {
  TaskFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFilterControllerHash();

  @$internal
  @override
  TaskFilterController create() => TaskFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$taskFilterControllerHash() =>
    r'024b206b29410d09bfa93d0d34b9482d9f5e031d';

abstract class _$TaskFilterController extends $Notifier<TaskFilter> {
  TaskFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TaskFilter, TaskFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskFilter, TaskFilter>,
              TaskFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AllTasksFilterController)
final allTasksFilterControllerProvider = AllTasksFilterControllerProvider._();

final class AllTasksFilterControllerProvider
    extends $NotifierProvider<AllTasksFilterController, TaskFilter> {
  AllTasksFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTasksFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTasksFilterControllerHash();

  @$internal
  @override
  AllTasksFilterController create() => AllTasksFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$allTasksFilterControllerHash() =>
    r'f8bb020d4d62c99d23fa17e7be8b0ee1917a90da';

abstract class _$AllTasksFilterController extends $Notifier<TaskFilter> {
  TaskFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TaskFilter, TaskFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskFilter, TaskFilter>,
              TaskFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CompletedTasksFilterController)
final completedTasksFilterControllerProvider =
    CompletedTasksFilterControllerProvider._();

final class CompletedTasksFilterControllerProvider
    extends $NotifierProvider<CompletedTasksFilterController, TaskFilter> {
  CompletedTasksFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedTasksFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedTasksFilterControllerHash();

  @$internal
  @override
  CompletedTasksFilterController create() => CompletedTasksFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$completedTasksFilterControllerHash() =>
    r'5b43740f72cb4bc85a369a4538682c2092df4f2b';

abstract class _$CompletedTasksFilterController extends $Notifier<TaskFilter> {
  TaskFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TaskFilter, TaskFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskFilter, TaskFilter>,
              TaskFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(IncompletedTasksFilterController)
final incompletedTasksFilterControllerProvider =
    IncompletedTasksFilterControllerProvider._();

final class IncompletedTasksFilterControllerProvider
    extends $NotifierProvider<IncompletedTasksFilterController, TaskFilter> {
  IncompletedTasksFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incompletedTasksFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incompletedTasksFilterControllerHash();

  @$internal
  @override
  IncompletedTasksFilterController create() =>
      IncompletedTasksFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$incompletedTasksFilterControllerHash() =>
    r'fea52681161b40789078ed0301d351563a717c02';

abstract class _$IncompletedTasksFilterController
    extends $Notifier<TaskFilter> {
  TaskFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TaskFilter, TaskFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskFilter, TaskFilter>,
              TaskFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
