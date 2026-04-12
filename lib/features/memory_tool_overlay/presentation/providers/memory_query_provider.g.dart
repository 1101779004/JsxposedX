// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memoryQueryRepository)
const memoryQueryRepositoryProvider = MemoryQueryRepositoryProvider._();

final class MemoryQueryRepositoryProvider
    extends
        $FunctionalProvider<
          MemoryQueryRepository,
          MemoryQueryRepository,
          MemoryQueryRepository
        >
    with $Provider<MemoryQueryRepository> {
  const MemoryQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemoryQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemoryQueryRepository create(Ref ref) {
    return memoryQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryQueryRepository>(value),
    );
  }
}

String _$memoryQueryRepositoryHash() =>
    r'7abade4ec3534418828e523063b523953ae30a7d';
