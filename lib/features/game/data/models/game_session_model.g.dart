// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameSessionModelCollection on Isar {
  IsarCollection<GameSessionModel> get gameSessionModels => this.collection();
}

const GameSessionModelSchema = CollectionSchema(
  name: r'GameSessionModel',
  id: -6004531957099909852,
  properties: {
    r'cells': PropertySchema(
      id: 0,
      name: r'cells',
      type: IsarType.objectList,

      target: r'CellModel',
    ),
    r'difficulty': PropertySchema(
      id: 1,
      name: r'difficulty',
      type: IsarType.byte,
      enumMap: _GameSessionModeldifficultyEnumValueMap,
    ),
    r'elapsedSeconds': PropertySchema(
      id: 2,
      name: r'elapsedSeconds',
      type: IsarType.long,
    ),
    r'gameStatus': PropertySchema(
      id: 3,
      name: r'gameStatus',
      type: IsarType.byte,
      enumMap: _GameSessionModelgameStatusEnumValueMap,
    ),
    r'mistakes': PropertySchema(id: 4, name: r'mistakes', type: IsarType.long),
    r'seed': PropertySchema(id: 5, name: r'seed', type: IsarType.long),
  },

  estimateSize: _gameSessionModelEstimateSize,
  serialize: _gameSessionModelSerialize,
  deserialize: _gameSessionModelDeserialize,
  deserializeProp: _gameSessionModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'CellModel': CellModelSchema},

  getId: _gameSessionModelGetId,
  getLinks: _gameSessionModelGetLinks,
  attach: _gameSessionModelAttach,
  version: '3.3.0',
);

int _gameSessionModelEstimateSize(
  GameSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cells.length * 3;
  {
    final offsets = allOffsets[CellModel]!;
    for (var i = 0; i < object.cells.length; i++) {
      final value = object.cells[i];
      bytesCount += CellModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _gameSessionModelSerialize(
  GameSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<CellModel>(
    offsets[0],
    allOffsets,
    CellModelSchema.serialize,
    object.cells,
  );
  writer.writeByte(offsets[1], object.difficulty.index);
  writer.writeLong(offsets[2], object.elapsedSeconds);
  writer.writeByte(offsets[3], object.gameStatus.index);
  writer.writeLong(offsets[4], object.mistakes);
  writer.writeLong(offsets[5], object.seed);
}

GameSessionModel _gameSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameSessionModel();
  object.cells =
      reader.readObjectList<CellModel>(
        offsets[0],
        CellModelSchema.deserialize,
        allOffsets,
        CellModel(),
      ) ??
      [];
  object.difficulty =
      _GameSessionModeldifficultyValueEnumMap[reader.readByteOrNull(
        offsets[1],
      )] ??
      Difficulty.easy;
  object.elapsedSeconds = reader.readLong(offsets[2]);
  object.gameStatus =
      _GameSessionModelgameStatusValueEnumMap[reader.readByteOrNull(
        offsets[3],
      )] ??
      GameStatus.initial;
  object.id = id;
  object.mistakes = reader.readLong(offsets[4]);
  object.seed = reader.readLong(offsets[5]);
  return object;
}

P _gameSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<CellModel>(
                offset,
                CellModelSchema.deserialize,
                allOffsets,
                CellModel(),
              ) ??
              [])
          as P;
    case 1:
      return (_GameSessionModeldifficultyValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              Difficulty.easy)
          as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_GameSessionModelgameStatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              GameStatus.initial)
          as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GameSessionModeldifficultyEnumValueMap = {
  'easy': 0,
  'medium': 1,
  'hard': 2,
};
const _GameSessionModeldifficultyValueEnumMap = {
  0: Difficulty.easy,
  1: Difficulty.medium,
  2: Difficulty.hard,
};
const _GameSessionModelgameStatusEnumValueMap = {
  'initial': 0,
  'playing': 1,
  'paused': 2,
  'complete': 3,
  'gameOver': 4,
};
const _GameSessionModelgameStatusValueEnumMap = {
  0: GameStatus.initial,
  1: GameStatus.playing,
  2: GameStatus.paused,
  3: GameStatus.complete,
  4: GameStatus.gameOver,
};

Id _gameSessionModelGetId(GameSessionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameSessionModelGetLinks(GameSessionModel object) {
  return [];
}

void _gameSessionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  GameSessionModel object,
) {
  object.id = id;
}

extension GameSessionModelQueryWhereSort
    on QueryBuilder<GameSessionModel, GameSessionModel, QWhere> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameSessionModelQueryWhere
    on QueryBuilder<GameSessionModel, GameSessionModel, QWhereClause> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameSessionModelQueryFilter
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cells', length, true, length, true);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cells', 0, true, 0, true);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cells', 0, false, 999999, true);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cells', 0, true, length, include);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cells', length, include, 999999, true);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cells',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  difficultyEqualTo(Difficulty value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'difficulty', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  difficultyGreaterThan(Difficulty value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficulty',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  difficultyLessThan(Difficulty value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficulty',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  difficultyBetween(
    Difficulty lower,
    Difficulty upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficulty',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  elapsedSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'elapsedSeconds', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  elapsedSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'elapsedSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  elapsedSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'elapsedSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  elapsedSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'elapsedSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameStatusEqualTo(GameStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameStatus', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameStatusGreaterThan(GameStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameStatusLessThan(GameStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameStatus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameStatusBetween(
    GameStatus lower,
    GameStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  mistakesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mistakes', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  mistakesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mistakes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  mistakesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mistakes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  mistakesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mistakes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  seedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seed', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  seedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  seedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  seedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameSessionModelQueryObject
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  cellsElement(FilterQuery<CellModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cells');
    });
  }
}

extension GameSessionModelQueryLinks
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {}

extension GameSessionModelQuerySortBy
    on QueryBuilder<GameSessionModel, GameSessionModel, QSortBy> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByElapsedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByElapsedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByGameStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameStatus', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByGameStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameStatus', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mistakes', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mistakes', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> sortBySeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortBySeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.desc);
    });
  }
}

extension GameSessionModelQuerySortThenBy
    on QueryBuilder<GameSessionModel, GameSessionModel, QSortThenBy> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficulty', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByElapsedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByElapsedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByGameStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameStatus', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByGameStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameStatus', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mistakes', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByMistakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mistakes', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> thenBySeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenBySeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.desc);
    });
  }
}

extension GameSessionModelQueryWhereDistinct
    on QueryBuilder<GameSessionModel, GameSessionModel, QDistinct> {
  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'difficulty');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByElapsedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'elapsedSeconds');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByGameStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameStatus');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByMistakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mistakes');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct> distinctBySeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seed');
    });
  }
}

extension GameSessionModelQueryProperty
    on QueryBuilder<GameSessionModel, GameSessionModel, QQueryProperty> {
  QueryBuilder<GameSessionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameSessionModel, List<CellModel>, QQueryOperations>
  cellsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cells');
    });
  }

  QueryBuilder<GameSessionModel, Difficulty, QQueryOperations>
  difficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficulty');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations>
  elapsedSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elapsedSeconds');
    });
  }

  QueryBuilder<GameSessionModel, GameStatus, QQueryOperations>
  gameStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameStatus');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations> mistakesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mistakes');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations> seedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seed');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CellModelSchema = Schema(
  name: r'CellModel',
  id: -2338816858777947365,
  properties: {
    r'answer': PropertySchema(id: 0, name: r'answer', type: IsarType.long),
    r'currentValue': PropertySchema(
      id: 1,
      name: r'currentValue',
      type: IsarType.long,
    ),
    r'isGiven': PropertySchema(id: 2, name: r'isGiven', type: IsarType.bool),
  },

  estimateSize: _cellModelEstimateSize,
  serialize: _cellModelSerialize,
  deserialize: _cellModelDeserialize,
  deserializeProp: _cellModelDeserializeProp,
);

int _cellModelEstimateSize(
  CellModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _cellModelSerialize(
  CellModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.answer);
  writer.writeLong(offsets[1], object.currentValue);
  writer.writeBool(offsets[2], object.isGiven);
}

CellModel _cellModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CellModel();
  object.answer = reader.readLong(offsets[0]);
  object.currentValue = reader.readLongOrNull(offsets[1]);
  object.isGiven = reader.readBool(offsets[2]);
  return object;
}

P _cellModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CellModelQueryFilter
    on QueryBuilder<CellModel, CellModel, QFilterCondition> {
  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> answerEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'answer', value: value),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> answerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'answer',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> answerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'answer',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> answerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'answer',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition>
  currentValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'currentValue'),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition>
  currentValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'currentValue'),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> currentValueEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentValue', value: value),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition>
  currentValueGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition>
  currentValueLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> currentValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CellModel, CellModel, QAfterFilterCondition> isGivenEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isGiven', value: value),
      );
    });
  }
}

extension CellModelQueryObject
    on QueryBuilder<CellModel, CellModel, QFilterCondition> {}
