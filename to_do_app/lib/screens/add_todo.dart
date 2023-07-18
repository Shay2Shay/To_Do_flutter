import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController title = TextEditingController();
  TextEditingController descr = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      title.text = widget.todo?['title'];
      descr.text = widget.todo?['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            child: Text(isEdit ? "Edit" : "Add New"),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descr,
              decoration: const InputDecoration(hintText: "Description"),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? "Update" : "Submit"),
              ),
            ),
          ],
        ));
  }

  Future<void> updateData() async {
    final msg = {
      "title": title.text,
      "description": descr.text,
      "is_completed": widget.todo?['is_completed']
    };

    final url = "https://api.nstack.in/v1/todos/${widget.todo?['_id']}";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(msg),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      title.text = "";
      descr.text = "";
      debugPrint("Update Successful !!");
      messageFlash("Update Successful !!", true);
    } else {
      debugPrint("Failed - Updation !! ");
      messageFlash("Failed - Updation !! ", false);
      debugPrint(response.body);
    }
  }

  Future<void> submitData() async {
    // print(title.text);
    final msg = {
      "title": title.text,
      "description": descr.text,
      "is_completed": false
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(msg),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      title.text = "";
      descr.text = "";
      debugPrint("Successfully Created !!");
      messageFlash("Successfully Created !!", true);
    } else {
      debugPrint("Failed - Creation !! ");
      messageFlash("Failed - Creation !! ", false);
      debugPrint(response.body);
    }
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
}
