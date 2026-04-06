// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isar)
final isarProvider = IsarProvider._();

final class IsarProvider extends $FunctionalProvider<Isar, Isar, Isar>
    with $Provider<Isar> {
  IsarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isarHash();

  @$internal
  @override
  $ProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Isar create(Ref ref) {
    return isar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Isar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Isar>(value),
    );
  }
}

String _$isarHash() => r'6013e20ce8cc6311a8437b538fc3f9419e75da5a';

@ProviderFor(sudokuRepository)
final sudokuRepositoryProvider = SudokuRepositoryProvider._();

final class SudokuRepositoryProvider
    extends
        $FunctionalProvider<
          SudokuRepository,
          SudokuRepository,
          SudokuRepository
        >
    with $Provider<SudokuRepository> {
  SudokuRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sudokuRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sudokuRepositoryHash();

  @$internal
  @override
  $ProviderElement<SudokuRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SudokuRepository create(Ref ref) {
    return sudokuRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SudokuRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SudokuRepository>(value),
    );
  }
}

String _$sudokuRepositoryHash() => r'adeb83cfca508b6b55ceecace04b588ce03acbd7';

@ProviderFor(generateSudokuUseCase)
final generateSudokuUseCaseProvider = GenerateSudokuUseCaseProvider._();

final class GenerateSudokuUseCaseProvider
    extends
        $FunctionalProvider<
          GenerateSudokuUsecase,
          GenerateSudokuUsecase,
          GenerateSudokuUsecase
        >
    with $Provider<GenerateSudokuUsecase> {
  GenerateSudokuUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generateSudokuUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generateSudokuUseCaseHash();

  @$internal
  @override
  $ProviderElement<GenerateSudokuUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GenerateSudokuUsecase create(Ref ref) {
    return generateSudokuUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerateSudokuUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerateSudokuUsecase>(value),
    );
  }
}

String _$generateSudokuUseCaseHash() =>
    r'3db3fdf0dc08a526a2080e9af244d165d96ed6b9';

@ProviderFor(saveGameUsecase)
final saveGameUsecaseProvider = SaveGameUsecaseProvider._();

final class SaveGameUsecaseProvider
    extends
        $FunctionalProvider<SaveGameUsecase, SaveGameUsecase, SaveGameUsecase>
    with $Provider<SaveGameUsecase> {
  SaveGameUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveGameUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveGameUsecaseHash();

  @$internal
  @override
  $ProviderElement<SaveGameUsecase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveGameUsecase create(Ref ref) {
    return saveGameUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveGameUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveGameUsecase>(value),
    );
  }
}

String _$saveGameUsecaseHash() => r'36b458232f2122a7a0eef5a0667c4395d63ca8e6';

@ProviderFor(loadGameUsecase)
final loadGameUsecaseProvider = LoadGameUsecaseProvider._();

final class LoadGameUsecaseProvider
    extends
        $FunctionalProvider<LoadGameUsecase, LoadGameUsecase, LoadGameUsecase>
    with $Provider<LoadGameUsecase> {
  LoadGameUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadGameUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadGameUsecaseHash();

  @$internal
  @override
  $ProviderElement<LoadGameUsecase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoadGameUsecase create(Ref ref) {
    return loadGameUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadGameUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadGameUsecase>(value),
    );
  }
}

String _$loadGameUsecaseHash() => r'ae74f8a5989687f5cb7c688c56c139da26120fff';
