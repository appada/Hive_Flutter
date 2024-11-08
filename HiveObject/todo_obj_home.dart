import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'todo_obj_model.dart';

class TodoObjHome extends StatefulWidget {
  const TodoObjHome({super.key});

  @override
  State<TodoObjHome> createState() => _TodoObjHomeState();
}

class _TodoObjHomeState extends State<TodoObjHome> {
  late Box<TodoObjModel> todoDataBox;
  final TextEditingController memoController = TextEditingController();
  int? editingIndex;

  @override
  void initState() {
    todoDataBox = Hive.box<TodoObjModel>('todoObjBox'); //openBox
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: memoController,
              decoration: const InputDecoration(labelText: 'MEMO'),
            ),
            buttonField(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: todoDataBox.listenable(),
                builder: (context, hiveObject, _) {
                  return ListView.builder(
                      itemCount: todoDataBox.length,
                      itemBuilder: (context, index) {
                        final todoDataList = todoDataBox.getAt(index);
                        return ListTile(
                            leading: Checkbox(
                                value: todoDataList!.isDone,
                                onChanged: (bool? v) {
                                  todoDataList.isDone = v!;
                                  todoDataList.save();
                                }),
                            title: Text(todoDataList.memo),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      memoController.text = todoDataList.memo;
                                      editingIndex = index;
                                    });
                                  },
                                  icon: Icon(Icons.edit_calendar),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      todoDataList.delete();
                                    }),
                              ],
                            ));
                      });
                },
              ),
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
            ? ElevatedButton(
                onPressed: () {
                  final addTodo = TodoObjModel(memo: memoController.text.trim());
                  todoDataBox.add(addTodo);
                },
                child: const Text('ADD'))
            : ElevatedButton(
                onPressed: () {
                  final updateTodo = TodoObjModel(memo: memoController.text.trim());
                  todoDataBox.put(editingIndex!, updateTodo);
                  setState(() {
                    editingIndex = null;
                    memoController.text = '';
                  });
                },
                child: const Text('Update'))
      ],
    );
  }

  //
  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }
}


// ElevatedButton(
//     onPressed: () {
//       final addTodo = TodoObjModel(memo: memoController.text.trim());
//       todoDataBox.add(addTodo);
//     },
//     child: const Text('ADD')),
