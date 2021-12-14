import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp_firebase/model/todo_model.dart';
class DataBase{
  FirebaseFirestore db=FirebaseFirestore.instance;
  Future<void> addTodo(Todo todo) async
  {
    try{
      await db.collection("Todos").add({
        'title': todo.title,
        'description': todo.description,
      });
    }catch(e){
      print(e);
    }
  }
  Future<Stream> getTodos()async
  {
    return db.collection("Todos").snapshots();
  }
  Future<void> updateTodo(Todo todo,int i)async{
    try{
      String id=await docId(i);
      await db.collection("Todos").doc(id).update(
        {
          'title': todo.title,
          'description': todo.description
        }
      );
    }catch(e){
      print(e);
    }
  }
  Future<void> deleteTodo(int i)async
  {
    try{
      String id=await docId(i);
      await db.collection("Todos").doc(id).delete();
    }catch(e){
      print(e);
    }
  }
  Future<String> docId(int i)async
  {
    QuerySnapshot querySnapshot= await db.collection("Todos").get();
    if(querySnapshot.docs.isNotEmpty){
      List list=querySnapshot.docs.toList();
      return list[i].id;
    }
    return "0";
  }
  Future<void> addSubTodo(Todo todo,int i) async
  {
    try{
      String id=await docId(i);
      await db.collection("Todos").doc(id).collection("SubTodos").add({
        'title': todo.title,
        'description': todo.description,
      });
    }catch(e){
      print(e);
    }
  }
  Future<Stream> getSubTodos(int i)async
  {
    String id=await docId(i);
    return db.collection("Todos").doc(id).collection("SubTodos").snapshots();
  }
  Future<void> updateSubTodo(Todo todo,int mainid,int subid)async{
    try{
      String id1=await docId(mainid);
      String id2=await getSubdocId(mainid,subid);

      await db.collection("Todos").doc(id1).collection("SubTodos").doc(id2).update(
          {
            'title': todo.title,
            'description': todo.description
          }
      );
    }catch(e){
      print(e);
    }
  }
  Future<void> deleteSubTodo(int mainid,int subid)async
  {
    try{
      String id1=await docId(mainid);
      String id2=await getSubdocId(mainid,subid);
      await db.collection("Todos").doc(id1).collection("SubTodos").doc(id2).delete();
    }catch(e){
      print(e);
    }
  }
  Future<String> getSubdocId(int mainid,int subid)async
  {
    String id=await docId(mainid);
    print(id);
    QuerySnapshot querySnapshot= await db.collection("Todos").doc(id).collection("SubTodos").get();
    if(querySnapshot.docs.isNotEmpty){
      List list=querySnapshot.docs.toList();
      print(list[subid].id);
      return list[subid].id;
    }
    return "0";
  }


}