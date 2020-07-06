import 'package:mobx/mobx.dart';
import 'package:todomobx/data/connection_db.dart';
import 'package:todomobx/models/todo_model.dart';
import 'package:todomobx/stores/todo_store.dart';
part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  final DbService db = DbService.instance;

  @observable
  String newTodoTitle = "";

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @observable
  bool done = false;

  @action
  Future<void> getList() async {
    final allNotes = await db.todoNotes();
    todoList.addAll(allNotes.reversed);
  }

  @action
  Future<void> addTodo() async{
    await db.insert(TodoNote(title: newTodoTitle));
    todoList.insert(0, TodoStore(TodoNote(title: newTodoTitle)));

    newTodoTitle = "";
  }
  
}
