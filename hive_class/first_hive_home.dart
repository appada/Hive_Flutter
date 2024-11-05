import 'package:about_hive/hive_1/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive_service.dart';

class FirstHiveHome extends StatefulWidget {
  const FirstHiveHome({super.key});

  @override
  State<FirstHiveHome> createState() => _FirstHiveHomeState();
}

class _FirstHiveHomeState extends State<FirstHiveHome> {
  final memoController = TextEditingController();
  late TodoService todoService;
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    todoService = TodoService(Hive.box<TodoModel>('firstTodo'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('first Todo')),
      body: Container(
        child: Column(
          children: [
            TextField(controller: memoController, decoration: const InputDecoration(labelText: 'MEMO')),
            buttonField(),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: Hive.box<TodoModel>('firstTodo').listenable(),
                  builder: (context, Box<TodoModel> hivebox, snapshot) {
                    return ListView.builder(
                        itemCount: hivebox.values.length,
                        itemBuilder: (context, index) {
                          TodoModel? todos = hivebox.getAt(index);
                          return ListTile(
                              leading: Checkbox(
                                  value: todos!.isDone,
                                  onChanged: (bool? v) {
                                    todoService.updateTodoStatus(index, v!);
                                  }),
                              title: Text(todos.memo),
                              subtitle: Text(todos.createdDate.toString()),
                              trailing: Wrap(
                                //row 는 렌더링에러를 발생한다. 랩으로
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        memoController.text = todos.memo;
                                        editingIndex = index;
                                      });
                                    },
                                    icon: Icon(Icons.edit_calendar),
                                  ),
                                  IconButton(
                                      onPressed: () => todoService.deleteTodoAt(index), icon: Icon(Icons.delete)),
                                ],
                              ));
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonField() {
    return Row(
      children: [
        editingIndex == null
            ? ElevatedButton(onPressed: () => todoService.addTodo(memoController.text.trim()), child: const Text('ADD'))
            : ElevatedButton(
                onPressed: () {
                  todoService.updateTodoAt(editingIndex!, memoController.text.trim());
                  setState(() {
                    editingIndex = null;
                    memoController.text = '';
                  });
                },
                child: const Text('Update'))
      ],
    );
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }
}

//  //
//   Future<void> addPressed() async {
//     TodoModel newTodo = TodoModel(memo: memoController.text.trim(), createdDate: DateTime.now());
//     await Hive.box<TodoModel>('firstTodo').add(newTodo);
//   }
