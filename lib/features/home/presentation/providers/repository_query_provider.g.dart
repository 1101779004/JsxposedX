// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repositoryQueryRepository)
const repositoryQueryRepositoryProvider = RepositoryQueryRepositoryProvider._();

final class RepositoryQueryRepositoryProvider
    extends
        $FunctionalProvider<
          RepositoryQueryRepository,
          RepositoryQueryRepository,
          RepositoryQueryRepository
        >
    with $Provider<RepositoryQueryRepository> {
  const RepositoryQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<RepositoryQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RepositoryQueryRepository create(Ref ref) {
    return repositoryQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepositoryQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RepositoryQueryRepository>(value),
    );
  }
}

String _$repositoryQueryRepositoryHash() =>
    r'a2b0b7ba29e9acec482795adbe5e22aab2661250';
