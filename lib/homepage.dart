import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesplus/addnote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesplus/viewnote.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> myColors = [
    Colors.grey,
    Colors.orangeAccent,
    Colors.lightGreen,
    Colors.brown,
    Colors.yellow,
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => AddNote(),
              ),
            )
                .then((value) {
              print('Calling Set State.!');
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
        appBar: AppBar(
          title: Text(
            'NotesPlus',
            style: TextStyle(
              fontSize: 26.0,
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black38,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('notes')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Random random = new Random();
                    Color bg = myColors[random.nextInt(5)];
                    Map? data = snapshot.data.docs[index].data() as Map?;
                    DateTime myDateTime = data!['created'].toDate();
                    String formattedTime =
                        DateFormat.yMMMd().add_jm().format(myDateTime);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ViewNote(
                              data,
                              formattedTime,
                              snapshot.data.docs[index].reference,
                            ),
                          ),
                        )
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Card(
                        color: bg,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data['title']}",
                                style: TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 0.0,
                                    top: 80.0,
                                    right: 0.0,
                                    bottom: 0.0),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  formattedTime,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('loading..'),
                );
              }
            }),
      ),
    );
  }
}
