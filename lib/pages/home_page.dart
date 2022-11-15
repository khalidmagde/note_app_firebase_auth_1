//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_1/pages/editnotes.dart';
import 'package:firebase_auth_1/pages/viewnote.dart';
import 'package:firebase_auth_1/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_1/auth.dart';

import 'addnotes.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Firebase Auth");
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _showData() {
    return StreamBuilder(
        stream: notesRef
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.hasData) {
            return Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          await notesRef.doc(snapshot.data.docs[i].id).delete();
                          await FirebaseStorage.instance
                              .refFromURL(snapshot.data.docs[i]['image'])
                              .delete();
                        },
                        key: UniqueKey(),
                        child: ListNotes(
                          notes: snapshot.data.docs[i],
                          docid: snapshot.data.docs[i].id,
                        ),
                      );
                      //Text("${snapshot.data.docs[i]['title']}");
                    }),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loding");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _showData(),
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  const ListNotes({Key? key, this.notes, this.docid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ViewNote(
              notes: notes,
            );
          }),
        );
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['image']}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']},${docid}"),
                subtitle: Text("${notes['note']}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return EditNotes(
                          docid: docid,
                          list: notes,
                        );
                      }),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
