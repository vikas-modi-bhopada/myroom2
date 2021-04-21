import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:roomi/user_data/user_profile_data.dart';

import 'UplodRoomDetails.dart';
import 'noRoomUploaded.dart';
import 'roomDetails.dart';

bool uplodingORnot = false;
String _userUid;
String _email;
String _farnistatus;
bool stdVal = false;
bool baVal = false;
bool boyVal = false;
bool girlVal = false;
bool anyVal = false;
String _membess;
String _bathroom;
// ignore: non_constant_identifier_names
String _no_of_beds;
DateTime selectedDate = DateTime.now();
String _preferedType = "Aynone";
String _propertyType;
String countryValue;
String stateValue;
String cityValue;
String addres;
String _status;
String ownerName;
String ownerCountry;
String ownerCity;
String ownerState;
String ownerContact;
String ownerAddres;
bool documentExists = true;
List<String> _filters = <String>[];

class EditRoom extends StatefulWidget {
  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  DocumentSnapshot documentSnapshot;
  _EditRoomState();

  static RoomDetails roomDetails = new RoomDetails();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      _userUid = value.uid;
      _email = value.email;
      UserData().getPerticularRoomDetails(_userUid).then((value) {
        setState(() {
          documentSnapshot = value;
          if (value.exists) {
            documentExists = true;

            roomDetails.setAddress(roomDetails, value.data['Address']);
          } else
            documentExists = false;
        });
      });
    });
    super.initState();
  }

  Text textWidgetForLocation(int index) {
    List<String> listOfLocation = List.from(documentSnapshot.data['Location']);
    String locationstr = "";
    listOfLocation.forEach((element) {
      locationstr = locationstr + " " + element;
    });
    return Text(
      locationstr,
      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Details',
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xfffbb448), Color(0xffe46b10)])),
              ),
              elevation: 0,
            ),
          ),
          body: documentExists
              ? documentSnapshot != null
                  ? Container(
                      child: SingleChildScrollView(child: getCards()),
                    )
                  : Center(
                      child: Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withAlpha(100),
                                    offset: Offset(2, 4),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ],
                              color: Colors.white),
                          child: CircularProgressIndicator()))
              : Center(
                  child: Text("You have not uploaded any room yet"),
                )),
    );
  }

  Widget getFirstCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  ResponsiveContainer(
                    widthPercent: 67,
                    heightPercent: 10,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${documentSnapshot['Overview']['room']} BHK in ${documentSnapshot['Address'][2]}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'At ${documentSnapshot['Address'][3]}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 26,
                    heightPercent: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                documentSnapshot['builtUpArea'].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sq. ft.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSecondCard() {
    String _deposit;
    String _rent;
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    ResponsiveContainer(
                      widthPercent: 47,
                      heightPercent: 10,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.rupeeSign,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    Text(
                                      "${documentSnapshot.data["depositAmount"]}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Security Deposit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ResponsiveContainer(
                      widthPercent: 47,
                      heightPercent: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              //                   <--- left side
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.rupeeSign,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    Text(
                                      "${documentSnapshot.data["monthlyRent"]}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.6)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Rent per month',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        right: 20,
        top: 5,
        child: InkWell(
          child: Icon(
            FontAwesomeIcons.solidEdit,
            size: 20,
            color: Colors.blue,
          ),
          onTap: () {
            Alert(
                context: context,
                title: "RENT",
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        icon: ImageIcon(
                          AssetImage('assets/icons/deposit.png'),
                          size: 25,
                        ),
                        labelText: 'Security Deposit  ',
                        alignLabelWithHint: true,
                      ),
                      onChanged: (value) {
                        _deposit = value;
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.rupeeSign),
                        labelText: 'Rent per Month',
                      ),
                      onChanged: (value) {
                        _rent = value;
                      },
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Firestore.instance
                          .collection("RoomDetails")
                          .document(_userUid)
                          .updateData({
                        'monthlyRent': _rent,
                        'depositAmount': _deposit
                      });
                      UserData()
                          .getPerticularRoomDetails(_userUid)
                          .then((value) {
                        setState(() {
                          documentSnapshot = value;
                        });
                      });
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      ),
    ]);
  }

  Widget getThirdCard() {
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    ResponsiveContainer(
                      widthPercent: 47,
                      heightPercent: 10,
                      child: Stack(children: [
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${documentSnapshot.data["Overview"]["furnishingStatus"]}', //'Fully Furnished',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                              ),
                              Container(
                                padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Furnishing Status',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              FontAwesomeIcons.solidEdit,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Alert(
                                  context: context,
                                  title: "FURNISHED STATUS",
                                  content: Center(
                                    child: MyStatefulWidget(),
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Firestore.instance
                                            .collection("RoomDetails")
                                            .document(_userUid)
                                            .updateData({
                                          'Overview.furnishingStatus':
                                              _farnistatus,
                                        });
                                        UserData()
                                            .getPerticularRoomDetails(_userUid)
                                            .then((value) {
                                          setState(() {
                                            documentSnapshot = value;
                                          });
                                        });
                                      },
                                      child: Text(
                                        "UPDATE",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                          ),
                        ),
                      ]),
                    ),
                    ResponsiveContainer(
                      widthPercent: 47,
                      heightPercent: 10,
                      child: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                //                   <--- left side
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${documentSnapshot.data["Overview"]["preferedType"]}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.6)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Container(
                                padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Prefered Tanents',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              FontAwesomeIcons.solidEdit,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Alert(
                                  context: context,
                                  title: "PREFERED TANENTS",
                                  content: Center(
                                    child: Tentype(),
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Firestore.instance
                                            .collection("RoomDetails")
                                            .document(_userUid)
                                            .updateData({
                                          'Overview.preferedType':
                                              _preferedType,
                                        });
                                        UserData()
                                            .getPerticularRoomDetails(_userUid)
                                            .then((value) {
                                          setState(() {
                                            documentSnapshot = value;
                                          });
                                        });
                                      },
                                      child: Text(
                                        "UPDATE",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget getFourthCard() {
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                  padding: new EdgeInsets.fromLTRB(10, 16, 10, 16),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'OVERVIEW',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ResponsiveContainer(
                                    widthPercent: 44,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          left: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.bed,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          documentSnapshot.data['Overview']
                                                      ['propertyType'] ==
                                                  "Room"
                                              ? Text(
                                                  '${documentSnapshot.data['Overview']['room']} Beds',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 20,
                                                  ),
                                                )
                                              : Text(
                                                  '${documentSnapshot.data['Overview']['room']} Bedrooms',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveContainer(
                                    widthPercent: 44,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          left: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.home,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            //'Apartment',
                                            '${documentSnapshot.data['Overview']['propertyType']}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveContainer(
                                    widthPercent: 44,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          left: BorderSide(
                                            color: Colors.grey,
                                            width: 1.5,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.users,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            //'Apartment',
                                            "${documentSnapshot.data["Members"]} Member",
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  ResponsiveContainer(
                                    widthPercent: 43,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.toilet,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${documentSnapshot.data['Overview']['bathroom']} Bathroom',
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveContainer(
                                    widthPercent: 43,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.calendarAlt,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format((documentSnapshot[
                                                            'Date Updated']
                                                        as Timestamp)
                                                    .toDate())
                                                .toString(),
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveContainer(
                                    widthPercent: 43,
                                    heightPercent: 7,
                                    child: Container(
                                      padding: new EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.key,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${documentSnapshot.data["status"]}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
      Positioned(
        right: 20,
        top: 20,
        child: InkWell(
          child: Icon(
            FontAwesomeIcons.solidEdit,
            size: 20,
            color: Colors.blue,
          ),
          onTap: () {
            Alert(
                context: context,
                title: "OVERVIEW",
                content: Column(
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.bed,
                          size: 25,
                        ),
                        labelText: 'Numbers OF Beds',
                        alignLabelWithHint: true,
                      ),
                      onChanged: (value) {
                        _no_of_beds = value;
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.bath),
                        labelText: 'Numbers of Bathrooms',
                      ),
                      onChanged: (value) {
                        _bathroom = value;
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.users),
                        labelText: 'Numbers of Members',
                      ),
                      onChanged: (value) {
                        _membess = value;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.home,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 40),
                        DropDownDemo(
                          st: "type",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.key,
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        DropDownDemo(
                          st: "other",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Date(),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Firestore.instance
                          .collection("RoomDetails")
                          .document(_userUid)
                          .updateData({
                        "Date Updated": selectedDate,
                        "status": _status,
                        "Members": _membess,
                        "Overview.bathroom": _bathroom,
                        "Overview.propertyType": _propertyType,
                        "Overview.room": _no_of_beds,
                      });
                      UserData()
                          .getPerticularRoomDetails(_userUid)
                          .then((value) {
                        setState(() {
                          documentSnapshot = value;
                        });
                      });
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      ),
    ]);
  }

  Widget getFifthCard() {
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                  padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.orange[500].withOpacity(0.6),
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text('FACILITIES',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        children: <Widget>[
                          for (var i in documentSnapshot['Facilities'])
                            getFacility(i)
                        ],
                      )

                      // Body Here
                    ],
                  )),
            ),
          ),
        ),
      ),
      Positioned(
        right: 20,
        top: 5,
        child: InkWell(
          child: Icon(
            FontAwesomeIcons.solidEdit,
            size: 20,
            color: Colors.blue,
          ),
          onTap: () {
            Alert(
                context: context,
                title: "FACILITIES",
                content: Center(
                  child: FacilitiesFilter(),
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Firestore.instance
                          .collection("RoomDetails")
                          .document(_userUid)
                          .updateData({
                        'Facilities': _filters,
                      });
                      UserData()
                          .getPerticularRoomDetails(_userUid)
                          .then((value) {
                        setState(() {
                          documentSnapshot = value;
                        });
                      });
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      ),
    ]);
  }

  // ignore: missing_return
  Widget getFacility(var fac) {
    switch (fac) {
      case 'Fire Safety':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),
              child: Image.asset(
                'assets/icons/fire-extinguisher.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Air Conditioner':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFFB849), Color(0xffD20B54)])),
              child: Image.asset(
                'assets/icons/ac.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Washing Machine':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff76BAFF), Color(0xff4EFFF8)])),
              child: Image.asset(
                'assets/icons/washing-machine.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Car Parking':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff3A40EE), Color(0xffF747AB)])),
              child: Image.asset(
                'assets/icons/parking.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Wi-Fi':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffff74a4), Color(0xffCA54D4)])),
              child: Image.asset(
                'assets/icons/wifi-signal.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Tiffin Facility':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffff74a4), Color(0xffCA54D4)])),
              child: Image.asset(
                'assets/icons/restaurant.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case '24x7 Water Supply':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),
              child: Image.asset(
                'assets/icons/water.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Garden':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff2BFBED), Color(0xffD9E021)])),
              child: Image.asset(
                'assets/icons/garden.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Lift':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFBBF36), Color(0xffF88D44)])),
              child: Image.asset(
                'assets/icons/lift.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case '24x7 CCTV':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffC8E234), Color(0xff6AEB34)])),
              child: Image.asset(
                'assets/icons/cctv.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Swimming Pool':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff77A5F8), Color(0xffD5A3FF)])),
              child: Image.asset(
                'assets/icons/swimming-pool.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Security':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffB26FEC), Color(0xff22E6B9)])),
              child: Image.asset(
                'assets/icons/watchman.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Children Park':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffB4FF4E), Color(0xff2FC145)])),
              child: Image.asset(
                'assets/icons/children-playarea.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Gym':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFCCF31), Color(0xffF55555)])),
              child: Image.asset(
                'assets/icons/dumbbell.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'HouseKeeping':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff60FF04), Color(0xff23EDED)])),
              child: Image.asset(
                'assets/icons/house-keeping.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
    }
  }

  // ignore: missing_retur
  Widget getSeventhCard() {
    List listOfAddress = documentSnapshot.data["Address"];
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                  padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.blue[500].withOpacity(0.6),
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text('ADDRESS',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          " ${documentSnapshot['Address'].elementAt(3)}" + ',',
                          style: TextStyle(
                            fontFamily: 'Ex02',
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          " ${documentSnapshot['Address'].elementAt(2)}" + ',',
                          style: TextStyle(
                            fontFamily: 'Ex02',
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${documentSnapshot['Address'].elementAt(1)}" + ',',
                          style: TextStyle(
                            fontFamily: 'Ex02',
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),

                      // Body Here
                    ],
                  )),
            ),
          ),
        ),
      ),
      Positioned(
        right: 20,
        top: 5,
        child: InkWell(
          child: Icon(
            FontAwesomeIcons.solidEdit,
            size: 20,
            color: Colors.blue,
          ),
          onTap: () {
            Alert(
                context: context,
                title: "PROPERTY ADDRESS",
                content: Center(
                  child: Column(
                    children: [
                      SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            print(value);
                            countryValue = value;

                            if (value != null) roomDetails.setCountry(value);
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                            if (value != null) roomDetails.setstate(value);
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            if (value != null) roomDetails.setCity(value);
                          });
                        },
                      ),
                      TextFormField(
                        maxLines: 2,
                        decoration: new InputDecoration(
                          labelText: "ADDRESS",
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 0.0, right: 0.0),
                        ),
                        onChanged: (String value) {
                          addres = value;
                          roomDetails.setColony(value);
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Address  is required' : null,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      List listOfAddress = new List();
                      listOfAddress.add(roomDetails.getCountry().toUpperCase());
                      listOfAddress.add(roomDetails.getState().toUpperCase());
                      listOfAddress.add(roomDetails.getCity().toUpperCase());
                      listOfAddress.add(roomDetails.getColony().toUpperCase());
                      List listofColony =
                          roomDetails.getColony().toUpperCase().split(' ');
                      listOfAddress.addAll(listofColony);
                      List listOfState =
                          roomDetails.getState().toUpperCase().split(" ");
                      listOfAddress.addAll(listOfState);

                      Navigator.pop(context);
                      Firestore.instance
                          .collection("RoomDetails")
                          .document(_userUid)
                          .updateData({'Address': listOfAddress});
                      UserData()
                          .getPerticularRoomDetails(_userUid)
                          .then((value) {
                        setState(() {
                          documentSnapshot = value;
                        });
                      });
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      ),
    ]);
  }

  Widget getEightCard() {
    return Stack(children: [
      Center(
        child: Card(
          elevation: 6,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(0.0),
              child: Container(
                  padding: new EdgeInsets.fromLTRB(10, 16, 10, 16),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.blue[500].withOpacity(0.6),
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'OWNER\'S DETAIL',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      getUserCard(context),
                      // Body Here
                    ],
                  )),
            ),
          ),
        ),
      ),
      Positioned(
        right: 20,
        top: 5,
        child: InkWell(
          child: Icon(
            FontAwesomeIcons.solidEdit,
            size: 20,
            color: Colors.blue,
          ),
          onTap: () {
            Alert(
                context: context,
                title: 'OWNER\'S DETAIL',
                content: Center(
                  child: Column(
                    children: [
                      SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            print(value);
                            ownerCountry = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            ownerState = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            ownerCity = value;
                          });
                        },
                      ),
                      TextFormField(
                        maxLines: 2,
                        decoration: new InputDecoration(
                          labelText: "ADDRESS",
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                        ),
                        onChanged: (String value) {
                          ownerAddres = value;
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Address  is required' : null,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.phoneAlt,
                            size: 25,
                          ),
                          labelText: 'Contact No. :',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          ownerContact = value;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.user,
                            size: 25,
                          ),
                          labelText: 'Name :',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          ownerName = value;
                        },
                      ),
                    ],
                  ),
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Firestore.instance
                          .collection("RoomDetails")
                          .document(_userUid)
                          .updateData({
                        'OwnerAdd': ownerAddres,
                        'OwnerName': ownerName,
                        'OwnerPhone': ownerContact,
                        'OwnerCountry': ownerCountry,
                        'OwnerState': ownerState,
                        'OwnerCity': ownerCity,
                      });
                      UserData()
                          .getPerticularRoomDetails(_userUid)
                          .then((value) {
                        setState(() {
                          documentSnapshot = value;
                        });
                      });
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
        ),
      ),
    ]);
  }

  Widget getUserCard(var context) {
    var size = Screen(MediaQuery.of(context).size);
    return Card(
      elevation: 0,
      borderOnForeground: true,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          //Fluttertoast.showToast(msg: "Card Tapped ${docsSnap['firstName']} ${docsSnap['lastName']}" );
        },
        child: Container(
          width: size.wp(100),
          height: size.hp(15),
          child: Row(
            children: <Widget>[
              Container(
                width: size.hp(14),
                color: Colors.grey,
                child: Image.asset('assets/icons/avatar.png'),
              ),
              Container(
                width: size.wp(84) - size.hp(16),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getWidthPx(0),
                      horizontal: size.getWidthPx(5)),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${documentSnapshot.data["OwnerName"]}",
                          style: TextStyle(
                              fontFamily: 'Ex02',
                              fontSize: size.getWidthPx(20),
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: size.getWidthPx(16),
                            color: Colors.grey,
                          ),
                          Text("${documentSnapshot.data["OwnerCity"]}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.getWidthPx(16))),
                        ],
                      ),
                      SizedBox(
                        height: size.getWidthPx(10),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("${documentSnapshot.data["OwnerPhone"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.getWidthPx(15))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCards() {
    return Container(
      padding: new EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: <Widget>[
          CarouselWithIndicator(documentSnapshot),

          documentSnapshot.data["Overview"]["propertyType"] != "Room"
              ? getFirstCard()
              : SizedBox(),

          getSecondCard(),

          getThirdCard(),

          getFourthCard(),

          getSeventhCard(),

          getFifthCard(),

          getEightCard(),
          // Tenth Card
        ],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // int groupValue=1;

  Widget build(BuildContext context) {
    return Column(
      //child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Radio(
                onChanged: (int e) => something(e),
                activeColor: Colors.orange[400],
                value: 1,
                groupValue: groupValue,
              ),
              Text(
                'Fully Furnished',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Radio(
                onChanged: (int e) => something(e),
                activeColor: Colors.orange[400],
                value: 2,
                groupValue: groupValue,
              ),
              Text(
                'Half Furnished',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Radio(
                onChanged: (int e) => something(e),
                activeColor: Colors.orange[400],
                value: 3,
                groupValue: groupValue,
              ),
              Text(
                'Not Furnished',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void something(int e) {
    setState(() {
      if (e == 1) {
        groupValue = 1;
        String apartment = 'Fully Furnished';
        _farnistatus = apartment;
      }
      if (e == 2) {
        groupValue = 2;
        String apartment = 'Half Furnished';
        _farnistatus = apartment;
      }
      if (e == 3) {
        groupValue = 3;
        String apartment = 'Not Furnished';
        _farnistatus = apartment;
      }
    });
  }
}

class Screen {
  Size screenSize;

  // ignore: unused_element
  Screen._internal();
  Screen(this.screenSize);

  double wp(percentage) {
    return percentage / 100 * screenSize.width;
  }

  double hp(percentage) {
    return percentage / 100 * screenSize.height;
  }

  double getWidthPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.width;
  }
}

// ignore: must_be_immutable
class CarouselWithIndicator extends StatefulWidget {
  final DocumentSnapshot snapshot;
  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(snapshot);
  CarouselWithIndicator(this.snapshot);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  final DocumentSnapshot snapshot;

  _CarouselWithIndicatorState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(children: [
        Swiper(
          autoplay: false,
          itemBuilder: (BuildContext context, int index) {
            return FullScreenWidget(
              backgroundIsTransparent: true,
              child: Image.network(
                snapshot.data['houseImages'][index].toString(),
                fit: BoxFit.contain,
              ),
            );
          },
          itemCount: snapshot['houseImages'].length,
          viewportFraction: 1,
          scale: 1,
          pagination: SwiperPagination(),
        ),
        Positioned(
          right: 20,
          top: 5,
          child: InkWell(
            child: Icon(
              FontAwesomeIcons.solidEdit,
              size: 20,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddImage(documentSnapshot: snapshot)));
            },
          ),
        ),
      ]),
    );
  }
}

class Tentype extends StatefulWidget {
  @override
  _TentypeState createState() => _TentypeState();
}

class _TentypeState extends State<Tentype> {
  // bool stdVal = false;
  // bool baVal = false;
  // bool boyVal = false;
  // bool girlVal = false;
  // bool anyVal = true;

  /// box widget
  /// [title] is the name of the checkbox
  /// [boolValue] is the boolean value of the checkbox
  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: boolValue,
              onChanged: (bool value) {
                /// manage the state of each value
                setState(() {
                  switch (title) {
                    case "Students":
                      stdVal = value;
                      baVal = false;
                      boyVal = false;
                      girlVal = false;
                      anyVal = false;

                      stdVal
                          ? _preferedType = "Students"
                          : _preferedType = "Anyone";

                      break;
                    case "Bachelors":
                      baVal = value;
                      stdVal = false;
                      boyVal = false;
                      girlVal = false;
                      anyVal = false;
                      baVal
                          ? _preferedType = "Bachelors"
                          : _preferedType = "Anyone";
                      break;
                    case "Boys Only":
                      boyVal = value;
                      stdVal = false;
                      baVal = false;
                      girlVal = false;
                      anyVal = false;
                      boyVal
                          ? _preferedType = "Boys Only"
                          : _preferedType = "Anyone";
                      break;
                    case "Girls Only":
                      girlVal = value;
                      stdVal = false;
                      baVal = false;
                      boyVal = false;
                      anyVal = false;
                      girlVal
                          ? _preferedType = "Girls Only"
                          : _preferedType = "Anyone";

                      break;
                    case "Anyone":
                      anyVal = value;
                      stdVal = false;
                      baVal = false;
                      boyVal = false;
                      girlVal = false;
                      anyVal
                          ? _preferedType = "Anyone"
                          : _preferedType = "Anyone";

                      break;
                  }
                });
              },
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              checkbox("Students", stdVal),
              checkbox("Bachelors", baVal),
              checkbox("Boys Only", boyVal),
              checkbox("Girls Only", girlVal),
              checkbox("Anyone", anyVal),
            ],
          ),
        ],
      ),
    );
  }
}

class FacilitiesFilter extends StatefulWidget {
  @override
  State createState() => FacilitiesFilterState();
}

class FacilitiesFilterState extends State<FacilitiesFilter> {
  final List<ActorFilterEntry> _cast = <ActorFilterEntry>[
    const ActorFilterEntry('Air Conditioner', 'AC'),
    const ActorFilterEntry('Washing Machine', 'WM'),
    const ActorFilterEntry('Car Parking', 'CP'),
    const ActorFilterEntry('Wi-Fi', 'WF'),
    const ActorFilterEntry('Tiffin Facility', 'TF'),
    const ActorFilterEntry('24x7 Water Supply', 'WF'),
    const ActorFilterEntry('Garden', 'GR'),
    const ActorFilterEntry('Lift', 'LF'),
    const ActorFilterEntry('24x7 CCTV', 'CC'),
    const ActorFilterEntry('Swimming Pool', 'SP'),
    const ActorFilterEntry('Security', 'SC'),
    const ActorFilterEntry('Children Park', 'CP'),
    const ActorFilterEntry('Gym', 'GY'),
    const ActorFilterEntry('HouseKeeping', 'HK'),
    const ActorFilterEntry('Fire Safety', 'FS'),
  ];

  Iterable<Widget> get actorWidgets sync* {
    for (ActorFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: FilterChip(
          label: Text(
            actor.name,
            style: new TextStyle(fontSize: 11.0),
          ),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(actor.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == actor.name;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: actorWidgets.toList(),
        ),
        Text(
          'Look for: ${_filters.join(', ')}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class Date extends StatefulWidget {
  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.calendarAlt,
          color: Colors.grey[600],
        ),
        SizedBox(
          width: 40,
        ),
        Text(
          DateFormat('dd/MM/yyyy').format(selectedDate).toString(),
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 20,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: Text("Select"),
          style: TextButton.styleFrom(elevation: 0.3),
        )
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.orange,
            ),
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}

// ignore: must_be_immutable
class DropDownDemo extends StatefulWidget {
  String st;
  DropDownDemo({Key key, @required this.st}) : super(key: key);
  @override
  _DropDownDemoState createState() => _DropDownDemoState(st);
}

class _DropDownDemoState extends State<DropDownDemo> {
  String st;
  _DropDownDemoState(this.st);

  @override
  Widget build(BuildContext context) {
    return st == "type"
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(0.0),
              child: DropdownButton<String>(
                value: _propertyType,
                //elevation: 5,
                style: TextStyle(color: Colors.black),

                items: <String>[
                  'Room',
                  'Flat',
                  'Apartment',
                  'Hostel',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Property Type",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _propertyType = value;
                  });
                },
              ),
            ),
          )
        : Center(
            child: Container(
              padding: const EdgeInsets.all(0.0),
              child: DropdownButton<String>(
                value: _status,
                //elevation: 5,
                style: TextStyle(color: Colors.black),

                items: <String>[
                  'Available',
                  'Not Available',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _status = value;
                  });
                },
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
class AddImage extends StatefulWidget {
  DocumentSnapshot documentSnapshot;

  AddImage({Key key, @required this.documentSnapshot}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState(documentSnapshot);
}

class _AddImageState extends State<AddImage> {
  DocumentSnapshot documentSnapshot;
  _AddImageState(this.documentSnapshot);
  bool uploading = false;
  bool button = true;
  List<dynamic> imageDataPath = <dynamic>[];
  @override
  void initState() {
    imageDataPath = documentSnapshot.data['houseImages'];
    super.initState();
  }

  var val;
  CollectionReference imgRef;
  // ignore: missing_return
  Future<bool> _back() {
    Navigator.pop(context);
  }

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)])),
            ),
            centerTitle: true,
            title: Text('Change Image'),
          ),
          body: Stack(
            children: [
              uplodingORnot
                  ? Center(
                      child: Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withAlpha(100),
                                    offset: Offset(2, 4),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ],
                              color: Colors.white),
                          child: CircularProgressIndicator()))
                  : Container(
                      padding: EdgeInsets.all(4),
                      child: GridView.builder(
                          itemCount: imageDataPath.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return index == 0
                                ? Center(
                                    child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            !uploading ? chooseImage() : null),
                                  )
                                : Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      imageDataPath[index - 1]),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 5,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.remove_circle,
                                              size: 25,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                imageDataPath
                                                    .removeAt(index - 1);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                    ),
              imageDataPath.length != 0
                  ? Align(
                      child: RawMaterialButton(
                        fillColor: Colors.white,
                        splashColor: Colors.greenAccent,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: !uplodingORnot
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "UPDATE IMAGES",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                )
                              : Text("LOADING IMAGE...."),
                        ),
                        shape: const StadiumBorder(),
                        onPressed: () {
                          setState(() {
                            uploading = true;
                            button = false;
                          });
                          Firestore.instance
                              .collection("RoomDetails")
                              .document(_userUid)
                              .updateData({
                            'houseImages': imageDataPath,
                          });
                          Fluttertoast.showToast(
                              msg: 'Details uploded  Successfully');
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRoom()));
                        },
                      ),
                      alignment: Alignment(0.0, .7),
                    )
                  : Align(
                      child: Text(
                        "Pleas Select Atleast one Image",
                        style: TextStyle(fontSize: 18),
                      ),
                      alignment: Alignment.center,
                    ),
            ],
          )),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile?.path);
      uploadFile();
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('$_email/image_NO_${DateTime.now()}');
    StorageUploadTask task = storageReference.putFile(_image);
    uplodingORnot = task.isInProgress;
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    print("\nUploaded: " + url);
    setState(() {
      uplodingORnot = false;
      imageDataPath.add(url);
    });
  }
}
