// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameNotifier)
final gameProvider = GameNotifierProvider._();

final class GameNotifierProvider
    extends $AsyncNotifierProvider<GameNotifier, GameSession?> {
  GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();
}

String _$gameNotifierHash() => r'ea1db9c0913a03faa46cc0079641b0d5bb98d0c3';

abstract class _$GameNotifier extends $AsyncNotifier<GameSession?> {
  FutureOr<GameSession?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GameSession?>, GameSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GameSession?>, GameSession?>,
              AsyncValue<GameSession?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
