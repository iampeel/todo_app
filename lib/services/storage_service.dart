import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class StorageService {
  static const String _key = 'todos';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // 저장
  Future<void> saveTodos(List<Todo> todos) async {
    final String encodedData = json.encode(
      todos.map((todo) => todo.toJson()).toList(),
    );
    await _prefs.setString(_key, encodedData);
  }

  // 불러오기
  Future<List<Todo>> loadTodos() async {
    final String? encodedData = _prefs.getString(_key);
    if (encodedData == null) return [];

    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData
        .map((item) => Todo.fromJson(item))
        .toList();
  }
}