import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel extends HiveObject{
  TodoModel({required this.memo,required this.createdDate});
  @HiveField(0)
  String memo;

  @HiveField(1)
  bool isDone = false;

  @HiveField(2)
  DateTime createdDate;

}
