// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VsNotifier)
final vsProvider = VsNotifierProvider._();

final class VsNotifierProvider extends $NotifierProvider<VsNotifier, VsState> {
  VsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vsNotifierHash();

  @$internal
  @override
  VsNotifier create() => VsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VsState>(value),
    );
  }
}

String _$vsNotifierHash() => r'3ad0849dd6c4787474b48012509db69614656bb5';

abstract class _$VsNotifier extends $Notifier<VsState> {
  VsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VsState, VsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VsState, VsState>,
              VsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
