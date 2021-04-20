import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:roomi/HouseFiles/ListofHouses.dart';

// ignore: must_be_immutable
class AddHouse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddHouseState();
  }
}

var ownerRef;

class AddHouseState extends State<AddHouse> {
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      userId = value.uid;
      _email = value.email;
      setState(() {});
    });
    super.initState();
  }

  Future<bool> _back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)])),
            ),
            title: Text('Property Address'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Wall()),
    );
  }
}

List<String> _filters = <String>[];
List<String> _filter = <String>[];
final databaseReference = Firestore.instance;
DocumentReference ref;
DocumentReference addd;
String _ownerPhone;
String __ownerName;
String _ownerAdd;
double _progress;
String _email;
String userId;
String _city;
String _state;
String _address;
String _buildup;
String _monthly;
String _deposit;
String _beds;
String _bath;
String _members;
int _value = 0;
int groupValue = 0;
String _farnistatus;
String _preferedType = "Aynone";
String _propert;
List<String> imageDataPath = <String>[];

class Wall extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WallState();
  }
}

class _WallState extends State<Wall> {
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Secondpage()));
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
            child: Container(
          color: Colors.grey[300],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(
                              Icons.my_location,
                              size: 30.0,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange,
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
                    TextFormField(
                      decoration: InputDecoration(labelText: 'State'),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.0,
                      ),
                      onSaved: (String value) {
                        _state = value;
                      },
                      validator: (value) =>
                          value.isEmpty ? 'State is required' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'City'),
                      onSaved: (String value) {
                        _city = value;
                      },
                      validator: (value) =>
                          value.isEmpty ? 'City is required' : null,
                    ),
                    TextFormField(
                      maxLines: 2,
                      decoration: new InputDecoration(
                        labelText: "Colony",
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 0.0, right: 0.0),
                      ),
                      onSaved: (String value) {
                        _address = value;
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Coloney Name  is required' : null,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: validateAndSave,
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                            elevation: 4.0,
                            color: Colors.orange[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class OwnerDetails extends StatefulWidget {
  @override
  _OwnerDetailsState createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddImage()));
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('OWNER DETAILS'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Center(
              child: Container(
            color: Colors.grey[300],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.person,
                                size: 30.0,
                                color: Colors.orange[400],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      //                   <--- left side
                                      color: Colors.orange[400],
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'OWNER DETAILS',
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
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16.0,
                        ),
                        onSaved: (String value) {
                          __ownerName = value;
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Name is required' : null,
                      ),
                      TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Contact No.'),
                        onSaved: (String value) {
                          _ownerPhone = value;
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Contact is required' : null,
                      ),
                      TextFormField(
                        maxLines: 2,
                        decoration: new InputDecoration(
                          labelText: "Address",
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 0.0, right: 0.0),
                        ),
                        onSaved: (String value) {
                          _ownerAdd = value;
                        },
                        validator: (value) =>
                            value.isEmpty ? 'Address Name  is required' : null,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              onPressed: validateAndSave,
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                              elevation: 4.0,
                              color: Colors.orange[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class Secondpage extends StatefulWidget {
  @override
  _MyFlutterAppState createState() => _MyFlutterAppState();
}

class _MyFlutterAppState extends State<Secondpage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post Free House Ad"),
          backgroundColor: Colors.orange[700],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Inte(),
      ),
    );
  }
}

class Inte extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InteState();
  }
}

class _InteState extends State<Inte> {
  final _formKey1 = GlobalKey<FormState>();
  // String _buildup;
  // String _monthly;
  // String _deposit;

  bool validateAndSave() {
    final form = _formKey1.currentState;
    if (form.validate()) {
      form.save();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Thirdpage()));

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[300],
          child: Card(
            margin: EdgeInsets.only(
                bottom: 10.0, left: 20.0, right: 20.0, top: 15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: 20.0, left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      //PROPERTY TYPE
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'PROPERTY TYPE',
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

                    Row(
                      //PROPERTY LIST
                      children: <Widget>[
                        //MyPropertyOptions(),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                            width: MediaQuery.of(context).size.width,
                            //color: Colors.black,
                            child: MyPropertyOptions(),
                          ),
                        )
                        //FacilitiesFilter(),
                      ],
                    ),

                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      //FACILITYS
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'FACILITIES',
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

                    Row(
                      //FACILITYS LIST
                      children: <Widget>[
                        //MyPropertyOptions(),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                            width: MediaQuery.of(context).size.width,
                            child: FacilitiesFilter(),
                          ),
                        )
                      ],
                    ),

                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      //FURNISHING STATUS
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'FURNISHING STATUS',
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

                    Row(
                      //FURNISHING STATUS LIST
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: MyStatefulWidget(),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      //MONTHLY RENT STATUS
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'MONTHLY RENT',
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

                    Row(
                      //MONTHLY RENT STATUS ENTRY
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        hintText: 'Monthly Rent in INR',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                      ),
                                      onSaved: (String value) {
                                        _monthly = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Monthly Rent is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "Rs/Month",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ), //ends

                    Row(
                      //DEPOSIT AMOUNT RENT STATUS
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'DEPOSIT AMOUNT',
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

                    Row(
                      //DEPOSIT AMOUNT STATUS ENTRY
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        hintText: 'Deposit Amount in INR',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                      ),
                                      onSaved: (String value) {
                                        _deposit = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Deposit Amount is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "Rs              ",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ), //ends

                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: validateAndSave,
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                            elevation: 4.0,
                            color: Colors.orange[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPropertyOptions extends StatefulWidget {
  @override
  _MyPropertyOptionsState createState() => _MyPropertyOptionsState();
}

class _MyPropertyOptionsState extends State<MyPropertyOptions> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: ChoiceChip(
              pressElevation: 0.0,
              backgroundColor: Colors.grey[300],
              selectedColor: Colors.black.withOpacity(0.3),
              avatar: CircleAvatar(
                backgroundColor: Color(0xff3ABBFA),
                child: Icon(
                  Icons.house_outlined,
                  color: Colors.black,
                ),
              ),
              label: Text(
                "Room",
                style: TextStyle(
                  color: (_value == 1) ? Colors.grey.shade200 : Colors.black87,
                ),
              ),
              selected: _value == 1,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? 1 : null;
                  String apartment = 'Room';
                  _propert = apartment;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: ChoiceChip(
              pressElevation: 0.0,
              backgroundColor: Colors.grey[300],
              selectedColor: Colors.grey[500],
              avatar: CircleAvatar(
                  backgroundColor: Color(0xffFBBF36), child: Icon(Icons.house)),
              label: Text(
                "Flat",
                style: TextStyle(
                  color: (_value == 2) ? Colors.grey.shade200 : Colors.black87,
                ),
              ),
              selected: _value == 2,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? 2 : null;
                  String apartment = 'Flat';
                  _propert = apartment;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: ChoiceChip(
              pressElevation: 0.0,
              backgroundColor: Colors.grey[300],
              selectedColor: Colors.grey[500],
              avatar: CircleAvatar(
                backgroundColor: Color(0xff83E934),
                child: Image.asset(
                  'assets/icons/flat.png',
                  width: double.infinity,
                ),
              ),
              label: Text(
                "Apartment",
                style: TextStyle(
                  color: (_value == 3) ? Colors.grey.shade200 : Colors.black87,
                ),
              ),
              selected: _value == 3,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? 3 : null;
                  String apartment = 'Apartment';
                  _propert = apartment;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: ChoiceChip(
              pressElevation: 0.0,
              backgroundColor: Colors.grey[300],
              selectedColor: Colors.grey[500],
              avatar: CircleAvatar(
                backgroundColor: Color(0xffA7A4FC),
                child: Image.asset(
                  'assets/icons/hostel.png',
                  width: double.infinity,
                ),
              ),
              label: Text(
                "Hostel",
                style: TextStyle(
                  color: (_value == 4) ? Colors.grey.shade200 : Colors.black87,
                ),
              ),
              selected: _value == 4,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? 4 : null;
                  String apartment = 'Hostel';
                  _propert = apartment;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final String initials;
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
        Text('Look for: ${_filters.join(', ')}'),
      ],
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

class Thirdpage extends StatefulWidget {
  @override
  _MyFlutterApp createState() => _MyFlutterApp();
}

class _MyFlutterApp extends State<Thirdpage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post Free House Ad"),
          backgroundColor: Colors.orange[700],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Finalfm(),
      ),
    );
  }
}

class Finalfm extends StatefulWidget {
  Finalfm({Key key}) : super(key: key);

  @override
  _Finalfmstate createState() => _Finalfmstate();
}

class _Finalfmstate extends State<Finalfm> {
  final _formKey2 = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey2.currentState;
    if (form.validate()) {
      form.save();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OwnerDetails()));
      //createRecord();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey2,
      child: Center(
        child: Container(
          color: Colors.grey[100],
          child: Card(
            margin: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      //DEPOSIT AMOUNT RENT STATUS
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: _value != 1
                                  ? Text(
                                      'NO. OF BEDROOMS',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    )
                                  : Text(
                                      'NO. OF BEDS',
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
                    Row(
                      //NO OF BEDROOMS ENTRY
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        //labelText: 'No. of Bedrooms',
                                        hintText: 'Enter No of Bedrooms',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                      ),
                                      onSaved: (String value) {
                                        _beds = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'No. of Bedrooms is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      //DEPOSIT AMOUNT RENT STATUS
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'NO. OF MEMBERS',
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        hintText: 'Enter No Of Members',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15.0),
                                      ),
                                      onSaved: (String value) {
                                        _members = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'No. of Members is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: const BoxDecoration(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      //DEPOSIT AMOUNT RENT STATUS
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'NO. OF BATHROOMS',
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
                    Row(
                      //NO OF BATHROOMS ENTRY
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        //labelText: "No. of Bathrooms",
                                        hintText: 'Enter No Of Bathrooms',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15.0),
                                      ),
                                      onSaved: (String value) {
                                        _bath = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'No. of Bathroom is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: const BoxDecoration(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      //build up area
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'BUILD AREA',
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
                    Row(
                      //Area of Property ENTRY
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        //labelText: "No. of Bathrooms",
                                        hintText:
                                            'Enter area of property Sp.ft.',
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(15.0),
                                      ),
                                      onSaved: (String value) {
                                        _buildup = value;
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Buildup area is required'
                                          : null,
                                      keyboardType: TextInputType.number,
                                      style: new TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: const BoxDecoration(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      //TYPESOFTANENT STATUS
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    //                   <--- left side
                                    color: Colors.orange[400],
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                'TYPES OF TENANT EXPECTING',
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
                    Tentype(),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: validateAndSave,
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                            elevation: 6.0,
                            color: Colors.orange[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool stdVal = false;
bool baVal = false;
bool boyVal = false;
bool girlVal = false;
bool anyVal = false;

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
            //Text(title),
            Checkbox(
              value: boolValue,
              onChanged: (bool value) {
                /// manage the state of each value
                setState(() {
                  switch (title) {
                    case "Students":
                      stdVal = value;
                      _preferedType = "Students";
                      break;
                    case "Bachelors":
                      baVal = value;
                      _preferedType = "Bachelors";
                      break;
                    case "Boys Only":
                      boyVal = value;
                      _preferedType = "Boys Only";
                      break;
                    case "Girls Only":
                      girlVal = value;
                      _preferedType = "Girls Only";
                      break;
                    case "Anyone":
                      anyVal = value;
                      _preferedType = "Anyone";
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

class AddImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddImage(),
    );
  }
}

void createRecord(context, uid) async {
  var address = {
    'city': _city,
    'state': _state,
    'society': _address,
  };
  var overview = {
    'bathroom': _bath,
    'room': _beds,
    'furnishingStatus': _farnistatus,
    'propertyType': _propert,
    'preferedType': _preferedType
  };
  Firestore.instance.collection("RoomDetails").document(userId).setData({
    'Address': address,
    'Date Created': DateTime.now(),
    'Date Updated': DateTime.now(),
    'Facilities': _filters,
    'Overview': overview,
    'favourite': 0,
    'houseImages': imageDataPath,
    'builtUpArea': _buildup,
    'depositAmount': _deposit,
    'monthlyRent': _monthly,
    'Members': _members,
    'OwnerName': __ownerName,
    'OwnerAdd': _ownerAdd,
    'OwnerPhone': _ownerPhone,
    'status': 'Available'
  });
  Navigator.pop(context);
  Navigator.pop(context);
  Fluttertoast.showToast(msg: 'Details uploded  Successfully');
  Navigator.push(context, MaterialPageRoute(builder: (_) => ListOfHouse()));
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Upload', icon: Icons.cloud_upload),
  const Choice(title: 'Post House Deal', icon: Icons.check)
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  bool button = true;
  var val;
  CollectionReference imgRef;
  Future<bool> _back() {
    Navigator.pop(context);
  }

  List<File> _image = [];
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
            title: Text('Add Image'),
          ),
          body: button
              ? Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      child: GridView.builder(
                          itemCount: _image.length + 1,
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
                                                  image: FileImage(
                                                      _image[index - 1]),
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
                                                _image.removeAt(index - 1);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          }),
                    ),
                    _image.length != 0
                        ? Align(
                            child: RawMaterialButton(
                              fillColor: Colors.white,
                              splashColor: Colors.greenAccent,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
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
                                      "Uplod Images",
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              shape: const StadiumBorder(),
                              onPressed: () {
                                setState(() {
                                  uploading = true;
                                  button = false;
                                });
                                uploadFile().whenComplete(
                                    () => createRecord(context, userId));
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
                )
              : Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        'uploading Details',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        animation: true,
                        animationDuration: 1000,
                        animateFromLastPercent: true,
                        lineHeight: 20.0,
                        percent: val,
                        center: Text("${(val * 100).toStringAsFixed(0)}%"),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ))),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
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
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('$_email/image_NO_${DateTime.now()}');
      StorageUploadTask task = storageReference.putFile(img);
      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      print("\nUploaded: " + url);
      imageDataPath.add(url);
      i++;
    }
  }
}
