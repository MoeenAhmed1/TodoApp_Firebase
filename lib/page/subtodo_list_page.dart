import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp_firebase/cubit/todo_cubit.dart';
import 'package:todoapp_firebase/model/todo_model.dart';
import 'package:todoapp_firebase/notification/firbase_notification.dart';
import 'package:todoapp_firebase/page/todo_form_page.dart';
import 'package:todoapp_firebase/repository/todo_repository.dart';
class SubTodoListPage extends StatefulWidget {
  final int mainIndex;
  final String description;
  final String title;

   const SubTodoListPage(this.mainIndex,this.title,this.description,{Key? key}) : super(key: key);

  @override
  _SubTodoListPageState createState() => _SubTodoListPageState();
}

class _SubTodoListPageState extends State<SubTodoListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (context)=>TodoCubit(DataBase(),PushNotification()),
    child: SubTodo(widget.mainIndex,widget.title,widget.description)
    );
  }
}
class SubTodo extends StatelessWidget {
  final int mainIndex;
  final String description;
  final String title;

  const SubTodo(this.mainIndex,this.title,this.description,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(title),
        ),
        body: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              context.read<TodoCubit>().getSubTodos(mainIndex);
              if(state is TodoLoaded) {
                return Column(
                  children: [
                    Expanded(child: StreamBuilder(
                      stream: state.todolist,
                      builder: (context,AsyncSnapshot snapshot){
                        if(snapshot.data==null)
                        {
                          return Scaffold();
                        }
                        return listBuilder(snapshot);
                      },
                    ),

                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  TodoFormPage(mainIndex)),
                              )
                      ),
                    ),
                  ],
                );
              }
              if(state is TodoLoading)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Scaffold();
            }
        )
    );
  }
  Widget listBuilder(snapshot)
  {
    return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index) {
          final String title = snapshot.data.docs[index].data()["title"];
          final String desc = snapshot.data.docs[index].data()["description"];
          return ListTile(

            title: Text(title),
            subtitle: Text(desc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read<TodoCubit>().deleteSubTodo(mainIndex,index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.update),
                  onPressed: () {
                    Todo todo=Todo(title,desc);
                    _displayTextInputDialog(context,index,todo);
                  },
                )
              ],
            ),
          );
        }

    );

  }
  Future<void> _displayTextInputDialog(BuildContext context,int id,Todo todo) async {
    final _titleController = TextEditingController();
    final _descController=TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Data'),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController..text=todo.title,

                    decoration: InputDecoration(hintText: "Enter Title"),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                      controller: _descController..text=todo.description,
                      decoration: InputDecoration(hintText: "Enter Title"),
                      keyboardType: TextInputType.multiline,
                      maxLines: null
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(

                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  Todo todo=Todo(_titleController.text,_descController.text);
                  final cubit=TodoCubit(DataBase(),PushNotification());
                  cubit.updateSubTodo(mainIndex, todo, id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

