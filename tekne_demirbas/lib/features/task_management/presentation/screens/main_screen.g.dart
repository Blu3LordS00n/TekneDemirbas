// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TabControllerState)
final tabControllerStateProvider = TabControllerStateProvider._();

final class TabControllerStateProvider
    extends $NotifierProvider<TabControllerState, TabController?> {
  TabControllerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabControllerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabControllerStateHash();

  @$internal
  @override
  TabControllerState create() => TabControllerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TabController? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TabController?>(value),
    );
  }
}

String _$tabControllerStateHash() =>
    r'e9f5b2b7e86bd11cc6fcffb1cad4a3bca12f2c0b';

abstract class _$TabControllerState extends $Notifier<TabController?> {
  TabController? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TabController?, TabController?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TabController?, TabController?>,
              TabController?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
