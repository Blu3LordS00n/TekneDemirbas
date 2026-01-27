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
}

String _$tabControllerStateHash() =>
    r'4a8b3c2d1e9f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2';

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
