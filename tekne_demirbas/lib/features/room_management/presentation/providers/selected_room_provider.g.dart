// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedRoom)
final selectedRoomProvider = SelectedRoomProvider._();

final class SelectedRoomProvider
    extends $NotifierProvider<SelectedRoom, String?> {
  SelectedRoomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRoomProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRoomHash();

  @$internal
  @override
  SelectedRoom create() => SelectedRoom();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedRoomHash() => r'e628fd794bf1485a468b6baf72462bba1d089ec4';

abstract class _$SelectedRoom extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
