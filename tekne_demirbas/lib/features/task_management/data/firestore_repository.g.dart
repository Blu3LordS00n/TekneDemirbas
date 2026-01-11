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
