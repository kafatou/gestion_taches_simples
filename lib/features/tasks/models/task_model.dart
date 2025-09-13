import 'package:hive_ce/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task {
  
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? status;
  @HiveField(3)
  String? dateBegin;
  @HiveField(4)
  String? dateEnd;

  int i = 0;

  Task(this.name, this.status, this.dateBegin, this.dateEnd){
    id=i;
    i++;
  }
}