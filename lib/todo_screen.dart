import 'package:fastcam_flutter_todo/data/todo_repository.dart';
import 'package:fastcam_flutter_todo/model/todo.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  final TodoRepository todoRepository;
  const TodoScreen({super.key, required this.todoRepository});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _addNewTodo() async {
    final text = await _showAddTodoDialog();
    if (text != null && text.isNotEmpty) {
      widget.todoRepository.createTodo(text);
    }
  }

  Future<String?> _showAddTodoDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your todo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

//status가 변경되지 않음. postman으로 patch 호출시 id만 넘기면 update안되고 그냥 원래값을 반환함
  void _toogleTodoStatus(Todo todo) {
    setState(() {
      todo.done = !todo.done;
    });
    widget.todoRepository.updateTodo(todo.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: RefreshIndicator(
            child: StreamBuilder<List<Todo>>(
              stream: widget.todoRepository.todoStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error fetching Todos ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Todo items'));
                }
                return ListView(
                  children: snapshot.data!
                      .map(
                        (todo) => TodoItem(
                          todo,
                          onChecked: () => _toogleTodoStatus(todo),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            onRefresh: () async {
              await widget.todoRepository.refreshTodos();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewTodo,
          tooltip: 'Add new Todo',
          child: const Icon(Icons.add),
        ),
      );
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onChecked;
  const TodoItem(this.todo, {super.key, required this.onChecked});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(todo.text),
        leading: Checkbox(
          onChanged: (bool? value) => onChecked(),
          value: todo.done,
        ),
      );
}
