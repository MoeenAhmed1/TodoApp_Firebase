import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoapp_firebase/cubit/todo_cubit.dart';
import 'package:todoapp_firebase/main.dart';
import 'package:todoapp_firebase/page/subtodo_list_page.dart';
import 'package:todoapp_firebase/page/todo_form_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          context.read<TodoCubit>().getTodos();
          if (state is TodoLoaded) {
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: state.todolist,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Scaffold();
                      }
                      return ListBuilder(snapshot);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoFormPage(-1)),
                          )),
                ),
              ],
            );
          }
          if (state is TodoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold();
        },
      ),
    );
  }

  Widget ListBuilder(snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index) {
          final String title = snapshot.data.docs[index].data()["title"];
          final String desc = snapshot.data.docs[index].data()["description"];

          return ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubTodoListPage(index, title, desc)),
            ),
            title: Text(title),
            subtitle: Text(desc),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read<TodoCubit>().deleteTodo(title, index);
                  },
                ),
              ],
            ),
          );
        });
  }
}
