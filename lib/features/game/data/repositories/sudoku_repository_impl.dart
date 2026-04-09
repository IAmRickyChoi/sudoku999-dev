import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sudoku_999/features/game/domain/entities/cell.dart';
import 'package:sudoku_999/features/game/domain/entities/difficulty.dart';
import 'package:sudoku_999/features/game/domain/entities/game_session.dart';
import 'package:sudoku_999/features/game/domain/entities/game_status.dart';
import 'package:sudoku_999/features/game/domain/entities/sudoku_board.dart';
import 'package:sudoku_999/features/game/domain/repositories/sudoku_repository.dart';

class SudokuRepositoryImpl implements SudokuRepository {
  // NAS 서버 API 주소
  final String baseUrl = 'http://192.168.1.163:8080/api';
  final String username;

  SudokuRepositoryImpl(this.username);

  @override
  Future<void> saveGame(GameSession gameSession) async {
    // 게스트는 저장하지 않음
    if (username == 'guest') return;

    final data = _sessionToJson(gameSession);

    try {
      await http.post(
        Uri.parse('$baseUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'data': data}),
      );
      print('서버 저장 완료 (保存完了)');
    } catch (e) {
      print('서버 저장 실패: $e');
    }
  }

  @override
  Future<GameSession?> loadGame() async {
    if (username == 'guest') return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/load?username=$username'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('서버 로드 완료 (ロード完了)');
        return _jsonToSession(data);
      }
    } catch (e) {
      print('서버 로드 실패: $e');
    }
    return null;
  }

  @override
  Future<void> clearSavedGame() async {
    // 향후 삭제가 필요하다면 서버에 Delete API를 구현하여 연결 (予約関数)
  }

  // --- JSON 직렬화 / 역직렬화 (시リアライズ / デシリアライズ) ---

  Map<String, dynamic> _sessionToJson(GameSession session) {
    return {
      'status': session.status.index,
      'difficulty': session.board.difficulty.index,
      'seed': session.board.seed,
      'mistakes': session.mistakes,
      'elapsedSeconds': session.elapsedSeconds,
      'cells': session.board.cells.map((row) {
        return row.map((cell) {
          return {
            'answer': cell.answer,
            'currentValue': cell.currentValue,
            'isGiven': cell.isGiven,
          };
        }).toList();
      }).toList(),
    };
  }

  GameSession _jsonToSession(Map<String, dynamic> json) {
    final cellsList = json['cells'] as List;

    List<List<Cell>> grid = cellsList.map((row) {
      return (row as List).map((c) {
        return Cell(
          answer: c['answer'] as int,
          currentValue: c['currentValue'] as int?,
          isGiven: c['isGiven'] as bool,
        );
      }).toList();
    }).toList();

    final board = SudokuBoard(
      cells: grid,
      difficulty: Difficulty.values[json['difficulty'] as int],
      seed: json['seed'] as int,
    );

    return GameSession(
      board: board,
      mistakes: json['mistakes'] as int,
      status: GameStatus.values[json['status'] as int],
      elapsedSeconds: json['elapsedSeconds'] as int,
    );
  }
}
