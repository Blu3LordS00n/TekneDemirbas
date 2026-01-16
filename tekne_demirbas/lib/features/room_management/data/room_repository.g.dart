// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomFirestore)
final roomFirestoreProvider = RoomFirestoreProvider._();

final class RoomFirestoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  RoomFirestoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomFirestoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomFirestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return roomFirestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$roomFirestoreHash() => r'01855daaf046000f689daffcb883c7718ac5e059';

@ProviderFor(roomRepository)
final roomRepositoryProvider = RoomRepositoryProvider._();

final class RoomRepositoryProvider
    extends $FunctionalProvider<RoomRepository, RoomRepository, RoomRepository>
    with $Provider<RoomRepository> {
  RoomRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoomRepository create(Ref ref) {
    return roomRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomRepository>(value),
    );
  }
}

String _$roomRepositoryHash() => r'181ada77cd2cac1e4a5ddca2a04ea80a4b752f31';

@ProviderFor(loadUserRooms)
final loadUserRoomsProvider = LoadUserRoomsFamily._();

final class LoadUserRoomsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Room>>,
          List<Room>,
          Stream<List<Room>>
        >
    with $FutureModifier<List<Room>>, $StreamProvider<List<Room>> {
  LoadUserRoomsProvider._({
    required LoadUserRoomsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadUserRoomsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadUserRoomsHash();

  @override
  String toString() {
    return r'loadUserRoomsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Room>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Room>> create(Ref ref) {
    final argument = this.argument as String;
    return loadUserRooms(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadUserRoomsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadUserRoomsHash() => r'5170a7da79e2035f215a2eddf0ce7ed139e80b18';

final class LoadUserRoomsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Room>>, String> {
  LoadUserRoomsFamily._()
    : super(
        retry: null,
        name: r'loadUserRoomsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadUserRoomsProvider call(String userId) =>
      LoadUserRoomsProvider._(argument: userId, from: this);

  @override
  String toString() => r'loadUserRoomsProvider';
}

@ProviderFor(loadUserRoomRequests)
final loadUserRoomRequestsProvider = LoadUserRoomRequestsFamily._();

final class LoadUserRoomRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoomRequest>>,
          List<RoomRequest>,
          Stream<List<RoomRequest>>
        >
    with
        $FutureModifier<List<RoomRequest>>,
        $StreamProvider<List<RoomRequest>> {
  LoadUserRoomRequestsProvider._({
    required LoadUserRoomRequestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadUserRoomRequestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadUserRoomRequestsHash();

  @override
  String toString() {
    return r'loadUserRoomRequestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RoomRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RoomRequest>> create(Ref ref) {
    final argument = this.argument as String;
    return loadUserRoomRequests(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadUserRoomRequestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadUserRoomRequestsHash() =>
    r'9d573d97bae595dd73be96645d5a365d11bafe2e';

final class LoadUserRoomRequestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RoomRequest>>, String> {
  LoadUserRoomRequestsFamily._()
    : super(
        retry: null,
        name: r'loadUserRoomRequestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadUserRoomRequestsProvider call(String userId) =>
      LoadUserRoomRequestsProvider._(argument: userId, from: this);

  @override
  String toString() => r'loadUserRoomRequestsProvider';
}

@ProviderFor(loadRoomRequestsForRoom)
final loadRoomRequestsForRoomProvider = LoadRoomRequestsForRoomFamily._();

final class LoadRoomRequestsForRoomProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoomRequest>>,
          List<RoomRequest>,
          Stream<List<RoomRequest>>
        >
    with
        $FutureModifier<List<RoomRequest>>,
        $StreamProvider<List<RoomRequest>> {
  LoadRoomRequestsForRoomProvider._({
    required LoadRoomRequestsForRoomFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadRoomRequestsForRoomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadRoomRequestsForRoomHash();

  @override
  String toString() {
    return r'loadRoomRequestsForRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RoomRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RoomRequest>> create(Ref ref) {
    final argument = this.argument as String;
    return loadRoomRequestsForRoom(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadRoomRequestsForRoomProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadRoomRequestsForRoomHash() =>
    r'32c12a03f2715d784558f10542e3ff5416044605';

final class LoadRoomRequestsForRoomFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RoomRequest>>, String> {
  LoadRoomRequestsForRoomFamily._()
    : super(
        retry: null,
        name: r'loadRoomRequestsForRoomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadRoomRequestsForRoomProvider call(String roomId) =>
      LoadRoomRequestsForRoomProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadRoomRequestsForRoomProvider';
}

@ProviderFor(loadRoom)
final loadRoomProvider = LoadRoomFamily._();

final class LoadRoomProvider
    extends $FunctionalProvider<AsyncValue<Room?>, Room?, Stream<Room?>>
    with $FutureModifier<Room?>, $StreamProvider<Room?> {
  LoadRoomProvider._({
    required LoadRoomFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadRoomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadRoomHash();

  @override
  String toString() {
    return r'loadRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Room?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Room?> create(Ref ref) {
    final argument = this.argument as String;
    return loadRoom(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadRoomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadRoomHash() => r'ff62cf90c69d2f6f666d4fe32ca7ba643cb7f55e';

final class LoadRoomFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Room?>, String> {
  LoadRoomFamily._()
    : super(
        retry: null,
        name: r'loadRoomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadRoomProvider call(String roomId) =>
      LoadRoomProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadRoomProvider';
}

@ProviderFor(loadUserPermission)
final loadUserPermissionProvider = LoadUserPermissionFamily._();

final class LoadUserPermissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoomPermission?>,
          RoomPermission?,
          Stream<RoomPermission?>
        >
    with $FutureModifier<RoomPermission?>, $StreamProvider<RoomPermission?> {
  LoadUserPermissionProvider._({
    required LoadUserPermissionFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'loadUserPermissionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadUserPermissionHash();

  @override
  String toString() {
    return r'loadUserPermissionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<RoomPermission?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RoomPermission?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return loadUserPermission(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadUserPermissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadUserPermissionHash() =>
    r'7ae7f3f1deb035c3b66f107077f07d71965a3dc8';

final class LoadUserPermissionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RoomPermission?>, (String, String)> {
  LoadUserPermissionFamily._()
    : super(
        retry: null,
        name: r'loadUserPermissionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadUserPermissionProvider call(String userId, String roomId) =>
      LoadUserPermissionProvider._(argument: (userId, roomId), from: this);

  @override
  String toString() => r'loadUserPermissionProvider';
}

@ProviderFor(loadRoomPermissions)
final loadRoomPermissionsProvider = LoadRoomPermissionsFamily._();

final class LoadRoomPermissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoomPermission>>,
          List<RoomPermission>,
          Stream<List<RoomPermission>>
        >
    with
        $FutureModifier<List<RoomPermission>>,
        $StreamProvider<List<RoomPermission>> {
  LoadRoomPermissionsProvider._({
    required LoadRoomPermissionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadRoomPermissionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadRoomPermissionsHash();

  @override
  String toString() {
    return r'loadRoomPermissionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RoomPermission>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RoomPermission>> create(Ref ref) {
    final argument = this.argument as String;
    return loadRoomPermissions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadRoomPermissionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadRoomPermissionsHash() =>
    r'0044cd3eed020b39fc390dc0e82eefb8597c8ffc';

final class LoadRoomPermissionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RoomPermission>>, String> {
  LoadRoomPermissionsFamily._()
    : super(
        retry: null,
        name: r'loadRoomPermissionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadRoomPermissionsProvider call(String roomId) =>
      LoadRoomPermissionsProvider._(argument: roomId, from: this);

  @override
  String toString() => r'loadRoomPermissionsProvider';
}

@ProviderFor(loadUserDisplayName)
final loadUserDisplayNameProvider = LoadUserDisplayNameFamily._();

final class LoadUserDisplayNameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  LoadUserDisplayNameProvider._({
    required LoadUserDisplayNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadUserDisplayNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadUserDisplayNameHash();

  @override
  String toString() {
    return r'loadUserDisplayNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    final argument = this.argument as String;
    return loadUserDisplayName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadUserDisplayNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadUserDisplayNameHash() =>
    r'e820d26e97da82f53226cd5c84f7294cd670d866';

final class LoadUserDisplayNameFamily extends $Family
    with $FunctionalFamilyOverride<Stream<String?>, String> {
  LoadUserDisplayNameFamily._()
    : super(
        retry: null,
        name: r'loadUserDisplayNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadUserDisplayNameProvider call(String userId) =>
      LoadUserDisplayNameProvider._(argument: userId, from: this);

  @override
  String toString() => r'loadUserDisplayNameProvider';
}

@ProviderFor(loadUserDisplayNameByEmail)
final loadUserDisplayNameByEmailProvider = LoadUserDisplayNameByEmailFamily._();

final class LoadUserDisplayNameByEmailProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  LoadUserDisplayNameByEmailProvider._({
    required LoadUserDisplayNameByEmailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadUserDisplayNameByEmailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadUserDisplayNameByEmailHash();

  @override
  String toString() {
    return r'loadUserDisplayNameByEmailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<String?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    final argument = this.argument as String;
    return loadUserDisplayNameByEmail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadUserDisplayNameByEmailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadUserDisplayNameByEmailHash() =>
    r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2';

final class LoadUserDisplayNameByEmailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<String?>, String> {
  LoadUserDisplayNameByEmailFamily._()
    : super(
        retry: null,
        name: r'loadUserDisplayNameByEmailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadUserDisplayNameByEmailProvider call(String email) =>
      LoadUserDisplayNameByEmailProvider._(argument: email, from: this);

  @override
  String toString() => r'loadUserDisplayNameByEmailProvider';
}

@ProviderFor(pendingRoomRequestsCount)
final pendingRoomRequestsCountProvider = PendingRoomRequestsCountFamily._();

final class PendingRoomRequestsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  PendingRoomRequestsCountProvider._({
    required PendingRoomRequestsCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingRoomRequestsCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingRoomRequestsCountHash();

  @override
  String toString() {
    return r'pendingRoomRequestsCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return pendingRoomRequestsCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingRoomRequestsCountProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingRoomRequestsCountHash() =>
    r'f8a3b2c1d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2';

final class PendingRoomRequestsCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  PendingRoomRequestsCountFamily._()
    : super(
        retry: null,
        name: r'pendingRoomRequestsCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PendingRoomRequestsCountProvider call(String roomId) =>
      PendingRoomRequestsCountProvider._(argument: roomId, from: this);

  @override
  String toString() => r'pendingRoomRequestsCountProvider';
}
