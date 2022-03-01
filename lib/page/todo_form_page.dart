import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp_firebase/cubit/todo_cubit.dart';
import 'package:todoapp_firebase/main.dart';
import 'package:todoapp_firebase/notification/firbase_notification.dart';
import 'package:todoapp_firebase/repository/todo_repository.dart';
import 'package:todoapp_firebase/model/todo_model.dart';
class TodoFormPage extends StatefulWidget {

  final int index;
  const TodoFormPage(this.index,{Key? key}) : super(key: key);

  @override
  _TodoFormPageState createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  DataBase repo=DataBase();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo form"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter Title',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null
          ),
          const SizedBox(height: 20,),
          TextField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: 'Enter Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            child: Text("Add"),
            onPressed:(){

              Todo todo=Todo(titleController.text,descController.text);
              final cubit=TodoCubit(repo,PushNotification());
              if(widget.index!=-1){
                cubit.addSubTodo(todo, widget.index);
                Navigator.pop(context);
              }
              else
                {
                  cubit.addTodo(todo);
                  Navigator.pop(context);
                }
            },
          )

        ],
      ),
    );
  }


}
