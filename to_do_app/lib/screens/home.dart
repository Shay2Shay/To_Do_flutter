import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("ToDo List"),
        title: Container(
          alignment: Alignment.center,
          child: const Text("ToDo List"),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final instance = items[index] as Map;
              final instanceID = instance['_id'] as String;

              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(instance['title']),
                    subtitle: Text(instance['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          // Open Edit Page
                          gotoEditPage(instance);
                        } else if (value == 'delete') {
                          // Delete value and update page
                          deleteByID(instanceID);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ];
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: gotoAddPage, label: const Text("Add Todo")),
    );
  }

  Future<void> gotoAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodo());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> gotoEditPage(Map instance) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(todo: instance),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  void messageFlash(String msg, bool good) {
    final color = good ? Colors.green : Colors.red;

    final snackbar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> deleteByID(String id) async {
    final uri = Uri.parse('https://api.nstack.in/v1/todos/$id');
    final res = await http.delete(uri);
    if (res.statusCode == 200) {
      setState(() {
        items = items.where((element) => element['_id'] != id).toList();
      });
    } else {
      messageFlash("Deletion Failed", false);
    }
  }

  Future<void> fetchTodo() async {
    final uri = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=10");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['items'] as List;
      // print(data['items'].length);

      setState(() {
        items = data;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}
