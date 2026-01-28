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
    r'fda178b2fee0386be14c26a26ff16ab281c256ca';

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
    r'b3e30b805f217d5d0584d3d5f091122c436207b3';

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
    r'f3d640f15b12da4f382bb0b4e3ea50ea647de9cd';

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
    r'a883fba91b2fae64f9a405fbca08a68a6dc63fc7';

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
