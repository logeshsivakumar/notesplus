import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0))),
                  ),
                  ElevatedButton(
                    onPressed: add,
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration.collapsed(hintText: "Title"),
                      style: TextStyle(
                        fontSize: 34.0,
                        fontFamily: "lato",
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (_val) {
                        title = _val;
                      },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration.collapsed(hintText: "Description"),
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.normal,
                        ),
                        onChanged: (_val) {
                          description = _val;
                        },
                        maxLines: 300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void add() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');
    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };
    ref.add(data);

    Navigator.pop(context);
  }
}
