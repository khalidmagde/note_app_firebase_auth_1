import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewNote extends StatefulWidget {
  final notes;
  const ViewNote({Key? key, this.notes}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View notes"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Image.network(
                "${widget.notes['image']}",
                width: 500,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "title note:  ${widget.notes['title']}",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Note :  ${widget.notes['note']}",
            ),
          ],
        ),
      ),
    );
  }
}
