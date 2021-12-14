import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoapp_firebase/model/todo_model.dart';
import 'package:todoapp_firebase/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {

  TodoCubit(this.db) : super(TodoInitial());
  final DataBase db;
  void getTodos() async
  {
    emit(TodoLoading());
    final res=await db.getTodos();
    emit(TodoLoaded(res));
  }
  void getSubTodos(int i)async
  {
    emit(TodoLoading());
    final res=await db.getSubTodos(i);
    emit(TodoLoaded(res));
  }
  void addTodo(Todo todo)
  {
    emit(TodoLoading());
    db.addTodo(todo);
  }
  void updateTodo(int id,Todo todo)
  {
    emit(TodoLoading());
    db.updateTodo(todo,id);
  }
  void deleteTodo(int id)
  {
    emit(TodoLoading());
    db.deleteTodo(id);

  }
  void addSubTodo(Todo todo,int i)
  {
    emit(TodoLoading());
    db.addSubTodo(todo,i);
  }
  void updateSubTodo(int id,Todo todo,int subid)
  {
    emit(TodoLoading());
    db.updateSubTodo(todo,id,subid);
  }
  void deleteSubTodo(int id,int subid)
  {
    emit(TodoLoading());
    db.deleteSubTodo(id,subid);

  }

}
