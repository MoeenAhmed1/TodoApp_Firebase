part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState{}
class TodoLoaded extends TodoState{
  final Stream todolist;


  TodoLoaded(this.todolist);
  Stream get todoList=>todolist;
}