import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // CollectionReference usersRef = FirebaseFirestore.instance.collection("users");

  var fbm = FirebaseMessaging.instance;

  late File file;

  var imagePicker = ImagePicker();

  uplodeImage() async {
    var imagrpicked = await imagePicker.getImage(source: ImageSource.camera);
    // ignore: unnecessary_null_comparison
    if (imagePicker != null) {
      file = File(imagrpicked!.path);
      var imgname = path.basename(imagrpicked.path);
      var random = Random().nextInt(100000000);
      print("====================");
      print("$random$imgname");
      /* print('=====================');
      print(imgname); */

      //start uploud

      //var refstorage = FirebaseStorage.instance.ref("imagesss/$imgname");
      //var refstorage = FirebaseStorage.instance.ref("$imgname");
      var refstorage = FirebaseStorage.instance
          .ref("avatar")
          .child("part1")
          .child("$imgname");

      await refstorage.putFile(file);

      var url = await refstorage.getDownloadURL();

      print("Url : $url");

      //end uploaud
    } else {
      print('choseeeeeeeeeee');
    }
  }

  /* GetImageAndFolder() async {
    var ref = await FirebaseStorage.instance.ref().list();
    /* ref.items.forEach((element) {
      print('==============');
      print(element.fullPath);
    }); */
    ref.prefixes.forEach((element) {
      print('==============');
      print(element.name);
    });
  } */

  @override
  void initState() {
    fbm.getToken().then((token) {
      print("============");
      print(token);
      print("================");
    });

    FirebaseMessaging.onMessage.listen((event) {
      print("==========EVENT==========");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Cloud Messaging"),
              content: Text("${event.notification!.body}"),
            );
          });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() async {
                  await uplodeImage();
                });
              },
              child: Text("Get Image"),
            ),
          ],
        ));
  }
}

/* StreamBuilder(
          stream: usersRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    return Text("${snapshot.data.docs[i]['age']}");
                  });
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loding");
            }
            return Text("l");
          }), */

/* ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text('Username : ${users[i]['username']}'),
              subtitle: Text('Phone : ${users[i]['phone']}'),
            );
          }), */

/* List users = [];
  CollectionReference usersdata =
      FirebaseFirestore.instance.collection("users");
  getList() async {
    var userdocs = await usersdata.get();
    userdocs.docs.forEach((element) {
      setState(() {
        users.add(element.data());
      });
    });
    //print(users);
  }

  @override
  void initState() {
    getList();
    super.initState();
  } */

getData() async {
  CollectionReference usersref = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot = await usersref.get();
  List<QueryDocumentSnapshot> listdocs = querySnapshot.docs;
  listdocs.forEach((element) {
    print(element.data());
    print('==========================');
  });
  /* var usersref =
        FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        print("==========");
      });
    }); */

//Get Data from firebase with condition

  /*  var usersref = FirebaseFirestore.instance
        .collection('users')
        .where('age', isLessThan: 40)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
        print("==========");
      });
    }); */

  //Get data in arrays from firebase

  /* var usersref = FirebaseFirestore.instance
        .collection('users')
        .where('lang', arrayContainsAny: ['ar', 'fr'])
        .get()
        .then((value) {
          value.docs.forEach((element) {
            print(element.data());
            print("==========");
          });
        }); */
// Update data real time firebase
  /* var usersref = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        print('Username : ${element.data()['username']}');
        print('email : ${element.data()['email']}');
        print('age : ${element.data()['age']}');
      });
    }); */
}

//--------------------------------------------------------------------
//add Data to firebase
addData() async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  userRef.add({
    "username": 'wael',
    "age": 58,
    "email": 'wael@gmail.com',
  });

  /*  userRef.doc('123456789').set({
      "username": 'shady',
      "age": 31,
      "email": 'shady@gmail.com',
    }); */
}

//-----------------------------------------------------------------------
//UpdateData from code
/* updateData() async {
    CollectionReference usersref =
        FirebaseFirestore.instance.collection('users');
    usersref
        .doc('123456789')
        .update({"username": 'shady', "age": 20}).then((value) {
      print("Data Updated");
    }).catchError((e) {
      print('Error : $e');
    });
  }
 */
//-----------------------------------------------------------------------------------
//Transaction
DocumentReference userdocs =
    FirebaseFirestore.instance.collection("users").doc("mqqpSjCinq9bk4pCN0iH");
trans() async {
  FirebaseFirestore.instance.runTransaction((transaction) async {
    //strat trans
    DocumentSnapshot docsnap = await transaction.get(userdocs);

    if (docsnap.exists) {
      transaction.update(userdocs, {
        "phone": ' 0999999',
      });
    } else {
      print('User not exist');
    }

    //end trans
  });
}

DocumentReference docOne =
    FirebaseFirestore.instance.collection("users").doc("123456789");
DocumentReference docTwo =
    FirebaseFirestore.instance.collection("users").doc("Eq9M16yBiI5HHeSsdEmY");

batcWrite() async {
  WriteBatch batch = FirebaseFirestore.instance.batch();

  batch.delete((docOne));
  batch.update(
      docTwo,
      ({
        'phone': 55555,
      }));
  batch.commit();
}

/* List users = [];
CollectionReference usersdata = FirebaseFirestore.instance.collection("users");
getList() async {
  var userdocs = await usersdata.get();
  userdocs.docs.forEach((element) {
    setState(() {
      users.add(element.data());
    });
  });
} */