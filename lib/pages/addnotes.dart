import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");
  Reference? ref;
  addnote() async {
    if (formState.currentState!.validate()) {
      if (file == null) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Please Choose Image"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              );
            }).then((value) {
          Navigator.of(context).pushNamed('homepage');
        }).catchError((e) {
          print(e);
        });
      }
    }

    if (formState.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      await ref!.putFile(file!);
      imageUrl = await ref!.getDownloadURL();

      await notesRef.add({
        "title": title.text,
        "note": note.text,
        "image": imageUrl,
        "userid": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Navigator.of(context).pushNamed('homepage');
      }).catchError((e) {
        print(e);
      });
    }
  }

  File? file;
  var imageUrl;
  final formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Container(
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: title,
                      decoration: const InputDecoration(
                        hintText: 'Title note',
                        prefixIcon: Icon(Icons.note_alt_rounded),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: note,
                      decoration: const InputDecoration(
                        hintText: 'Note',
                        prefixIcon: Icon(Icons.note_alt_rounded),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ShowBottomSheet();
                        },
                        child: const Text('Add Image for note')),
                    MaterialButton(
                      onPressed: () async {
                        addnote();
                      },
                      child: const Text("Add Note"),
                      textColor: Colors.white,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ShowBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "please Chossse Image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    file = File(picked!.path);
                    var rand = Random().nextInt(100000);
                    var imgName = '$rand' + Path.basename(picked.path);

                    ref = FirebaseStorage.instance
                        .ref("images")
                        .child("$imgName");

                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.photo_album_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Gallery",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);

                    file = File(picked!.path);
                    var rand = Random().nextInt(100000);
                    var imgName = '$rand' + Path.basename(picked.path);

                    ref = FirebaseStorage.instance
                        .ref("images")
                        .child("$imgName");

                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Camera",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
