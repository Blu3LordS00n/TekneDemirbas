// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, dynamic> {
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'956e27a25642a971c67eebfdcbd35c92d24f7725';

abstract class _$AuthController extends $AsyncNotifier<dynamic> {
  FutureOr<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, dynamic>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
