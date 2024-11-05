import 'package:hive/hive.dart';
import 'package:about_hive/hive_1/model/todo_model.dart';

class TodoService {
  final Box<TodoModel> _todoBox;

  TodoService(this._todoBox);

  Future<void> addTodo(String memo) async {
    TodoModel newTodo = TodoModel(
      memo: memo.trim(),
      createdDate: DateTime.now(),
    );
    await _todoBox.add(newTodo);
  }

  Future<void> deleteTodoAt(int index) async {
    await _todoBox.deleteAt(index);
  }

  Future<void> updateTodoAt(int index, String memo) async {
    TodoModel? todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.memo = memo;
      await _todoBox.putAt(index, todo);
    }
  }

  Future<void> updateTodoStatus(int index, bool isDone) async {
    TodoModel? todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.isDone = isDone;
      await _todoBox.putAt(index, todo);
    }
  }

  List<TodoModel> getTodos() {
    return _todoBox.values.toList();
  }
}
