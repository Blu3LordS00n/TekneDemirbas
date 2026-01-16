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
    r'cbfea46d6381db02cfac594d378ef6a85947e526';

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
    r'dcfeb56e7492ec13dgad605e489fg970b97048f637';

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
final completedTasksFilterControllerProvider = CompletedTasksFilterControllerProvider._();

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
    r'ecfgb67f8503fd24ehbe716f59ag081c08159g748';

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
final incompletedTasksFilterControllerProvider = IncompletedTasksFilterControllerProvider._();

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
  IncompletedTasksFilterController create() => IncompletedTasksFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$incompletedTasksFilterControllerHash() =>
    r'fcghc78g9614ge35ficg827g60bh192d19260h859';

abstract class _$IncompletedTasksFilterController extends $Notifier<TaskFilter> {
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
