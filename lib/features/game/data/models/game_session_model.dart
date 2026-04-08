import 'package:isar_community/isar.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart';

part 'game_session_model.g.dart';

@collection
class GameSessionModel {
  Id id = Isar.autoIncrement;

  @enumerated
  late GameStatus gameStatus;
  @enumerated
  late Difficulty difficulty;

  late int seed;
  late int mistakes;
  late int elapsedSeconds;

  late List<CellModel> cells;
}

@embedded
class CellModel {
  late int answer;
  int? currentValue;
  late bool isGiven;
}
