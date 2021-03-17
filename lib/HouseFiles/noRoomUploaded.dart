import 'package:flutter/material.dart';

class NoRoomUploaded extends StatefulWidget {
  @override
  _NoRoomUploadedState createState() => _NoRoomUploadedState();
}

class _NoRoomUploadedState extends State<NoRoomUploaded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "You have not uploaded any rooms yet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
