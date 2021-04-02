import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomi/user_data/user_profile_data.dart';

class EditRoomDetails extends StatefulWidget {
  @override
  _EditRoomDetailsState createState() => _EditRoomDetailsState();
}

class _EditRoomDetailsState extends State<EditRoomDetails> {
  final _formKey = GlobalKey<FormState>();
  String _userUid;
  Map mapOfAddress;
  String state;
  String city;
  String colony;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      _userUid = value.uid;
      setState(() {
        UserData().getPerticularRoomDetails(_userUid).then((value) {
          mapOfAddress = value.data['Address'];
          setState(() {
            mapOfAddress.forEach((key, value) {
              switch (key) {
                case 'city':
                  city = value;
                  print(city);
                  break;
                case 'society':
                  colony = value;
                  print(colony);
                  break;
                case 'state':
                  state = value;
                  print(state);
                  break;
              }
            });
          });
        });
      });
    });
    super.initState();
  }

  bool validAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        // ======== AppBar of Scaffold ========
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text('Update Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        //============Body of Scaffold ===========
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              color: Colors.grey[300],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              // ========== Card Widget ========

              child: Card(
                margin: EdgeInsets.only(
                    bottom: 10.0, left: 20.0, right: 20.0, top: 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ======= Adderess Text =========

                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        //                   <--- left side
                                        color: Colors.blue[400],
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'ADDRESS',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // =======   State Field ======

                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'State',
                            hintText: state
                          ),
                        ),

                        // =======   City Field ======

                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'City',
                            hintText: city
                          ),
                        ),

                        // =======   Colony Field ======

                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'Colony',
                            hintText: colony
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
