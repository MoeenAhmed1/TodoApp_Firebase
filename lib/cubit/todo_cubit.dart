import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoapp_firebase/model/todo_model.dart';
import 'package:todoapp_firebase/notification/firbase_notification.dart';
import 'package:todoapp_firebase/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  DataBase db;
  PushNotification notification;
  TodoCubit(this.db, this.notification) : super(TodoInitial());
  void getTodos() async {
    emit(TodoLoading());
    final res = await db.getTodos();
    emit(TodoLoaded(res));
  }

  void getSubTodos(int i) async {
    emit(TodoLoading());
    final res = await db.getSubTodos(i);
    emit(TodoLoaded(res));
  }

  void addTodo(Todo todo) {
    emit(TodoLoading());

    db.addTodo(todo);
    notification.notifyUser(todo.title, "add");
  }

  void updateTodo(int id, Todo todo) {
    emit(TodoLoading());

    db.updateTodo(todo, id);
    notification.notifyUser(todo.title, "update");
  }

  void deleteTodo(String title, int id) {
    emit(TodoLoading());
    db.deleteTodo(id);
    notification.notifyUser(title, "delete");
  }

  void addSubTodo(Todo todo, int i) {
    emit(TodoLoading());
    db.addSubTodo(todo, i);
  }

  void updateSubTodo(int id, Todo todo, int subid) {
    emit(TodoLoading());
    db.updateSubTodo(todo, id, subid);
  }

  void deleteSubTodo(int id, int subid) {
    emit(TodoLoading());
    db.deleteSubTodo(id, subid);
  }
}
