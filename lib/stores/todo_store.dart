import 'package:mobx/mobx.dart';
import 'package:todomobx/data/connection_db.dart';
import 'package:todomobx/models/todo_model.dart';
part 'todo_store.g.dart';

class TodoStore = _TodoStoreBase with _$TodoStore;

abstract class _TodoStoreBase with Store {
  TodoNote todo;

  _TodoStoreBase(this.todo);

  final DbService db = DbService.instance;

  @observable
  bool done = false;

  @action
  Future<void> updateNote() async {
    done = !done;
    todo.done == 1 ? todo.done = 0 : todo.done = 1;

    await db.update(todo);
  }
}
