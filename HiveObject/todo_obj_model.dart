import 'package:hive/hive.dart';

part 'todo_obj_model.g.dart';

@HiveType(typeId: 4)
class TodoObjModel extends HiveObject{
  @HiveField(0)
  String memo;
  @HiveField(1)
  bool isDone = false;

  TodoObjModel({required this.memo});
}

