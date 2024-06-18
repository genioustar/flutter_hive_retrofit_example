import 'dart:async';

import 'package:fastcam_flutter_todo/api/api_service.dart';
import 'package:fastcam_flutter_todo/model/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoRepository {
  final ApiService _apiService;
  final Box<Todo> _todoBox;
  final _todosController = StreamController<List<Todo>>();

  TodoRepository(this._apiService, this._todoBox) {
    _initialize();
  }

  Stream<List<Todo>> get todoStream => _todosController.stream;

  void _initialize() async {
    _emitCachedDate();
    await _fetchAndCacheTodos();
  }

  void _emitCachedDate() {
    final cachedTodos = _todoBox.values.toList();
    _todosController.add(cachedTodos);
  }

  Future<void> _fetchAndCacheTodos() async {
    try {
      final todos = await _apiService.getTodos();
      for (final todo in todos) {
        _todoBox.put(todo.id, todo);
      }
      _emitCachedDate();
    } catch (e) {
      print('Error fetching Todos : $e');
    }
  }

  Future<void> createTodo(String text) async {
    try {
      final newTodo = await _apiService.createTodo(Todo(id: '', text: text));
      _todoBox.put(newTodo.id, newTodo);
      _emitCachedDate();
    } catch (e) {
      print('Error creating Todo : $e');
    }
  }

  Future<void> updateTodo(String id) async {
    try {
      final updatedTodo = await _apiService.updateTodo(id);
      print('Updated Todo : ${updatedTodo.id} - ${updatedTodo.done} ');
      _todoBox.put(id, updatedTodo);
      _emitCachedDate();
    } catch (e) {
      print('Error updating Todo : $e');
    }
  }

  Future<void> refreshTodos() async {
    await _fetchAndCacheTodos();
  }

  void dispose() {
    _todosController.close();
  }
}
