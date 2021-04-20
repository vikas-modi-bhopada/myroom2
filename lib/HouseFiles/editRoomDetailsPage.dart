import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomi/HouseFiles/roomDetails.dart';
import 'package:roomi/Shared/loadingwidget.dart';
import 'package:roomi/user_data/user_profile_data.dart';

String _email;
String _userUid;

class EditRoomDetails extends StatefulWidget {
  @override
  _EditRoomDetailsState createState() => _EditRoomDetailsState();
}

class _EditRoomDetailsState extends State<EditRoomDetails> {
  final _formKey = GlobalKey<FormState>();

  Map mapOfAddress;
  Map mapOfOverview;
  int _value = 0;
  int selectedRadio = 0;
  bool valueofCheck = false;
  bool studentVal = false;
  bool bachelorsval = false;
  bool boysonlyval = false;
  bool girlsonlyval = false;
  bool anyoneval = false;

  DocumentSnapshot documentSnapshot;
  static RoomDetails roomDetails = new RoomDetails();

  void checkFurnishingStaus() {
    String furnishingStatus = roomDetails.getfurnishingStatus();
    switch (furnishingStatus) {
      case 'Fully Furnished':
        selectedRadio = 1;
        break;
      case 'Half Furnished':
        selectedRadio = 2;
        break;
      case 'Not Furnished':
        selectedRadio = 3;
        break;
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      _userUid = value.uid;
      _email = value.email;
      setState(() {
        UserData().getPerticularRoomDetails(_userUid).then((value) {
          documentSnapshot = value;
          mapOfAddress = value.data['Address'];
          roomDetails.setStateCityColony(mapOfAddress);
          mapOfOverview = value.data['Overview'];
          roomDetails.setBathroomFurnishStatusPreferedTypePropertyTypeRoom(
              mapOfOverview);
          roomDetails.setFacilities(value.data['Facilities']);
          roomDetails.setMonthlyRent(value.data['monthlyRent']);
          roomDetails.setDepositAmount(value.data['depositAmount']);
          roomDetails.setNoOfMemebers(value.data['Members']);
          roomDetails.setbuildArea(value.data['builtUpArea']);
          checkFurnishingStaus();
          checkDataBaseDataOfTenantType();
          roomDetails.setOwnerName(value.data['OwnerName']);
          roomDetails.setOwnerAddress(value.data['OwnerAdd']);
          roomDetails.setOwnerContactNO(value.data['OwnerPhone']);
          setState(() {});
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

  Widget buildRow(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue[400],
                    width: 3.0,
                  ),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget listOfPropertyType() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Wrap(
                children: <Widget>[
// ==============  ChoiceChip For Room ===========

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
                          color: (roomDetails.getpropertyType() == "Room")
                              ? Colors.grey.shade200
                              : Colors.black87,
                        ),
                      ),
                      selected: _value == 1,
                      onSelected: (bool selected) {
                        if (selected) {
                          String apartment = 'Room';
                          roomDetails.setPropertyType(apartment);
                        }
                        setState(() {});
                      },
                    ),
                  ),

// ==============  ChoiceChip For Flat ===========

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: ChoiceChip(
                      pressElevation: 0.0,
                      backgroundColor: Colors.grey[300],
                      selectedColor: Colors.grey[500],
                      avatar: CircleAvatar(
                          backgroundColor: Color(0xffFBBF36),
                          child: Icon(Icons.house)),
                      label: Text(
                        "Flat",
                        style: TextStyle(
                          color: (roomDetails.getpropertyType() == "Flat")
                              ? Colors.grey.shade200
                              : Colors.black87,
                        ),
                      ),
                      selected: _value == 2,
                      onSelected: (bool selected) {
                        if (selected) {
                          String apartment = 'Flat';
                          roomDetails.setPropertyType(apartment);
                        }
                        setState(() {});
                      },
                    ),
                  ),

// ==============  ChoiceChip For Apartment ===========

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
                          color: (roomDetails.getpropertyType() == "Apartment")
                              ? Colors.grey.shade200
                              : Colors.black87,
                        ),
                      ),
                      selected: _value == 3,
                      onSelected: (bool selected) {
                        if (selected) {
                          String apartment = 'Apartment';
                          roomDetails.setPropertyType(apartment);
                        }
                        setState(() {});
                      },
                    ),
                  ),

// ==============  ChoiceChip For Hostel ===========

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
                          color: (roomDetails.getpropertyType() == "Hostel")
                              ? Colors.grey.shade200
                              : Colors.black87,
                        ),
                      ),
                      selected: _value == 4,
                      onSelected: (bool selected) {
                        if (selected) {
                          String apartment = 'Hostel';
                          roomDetails.setPropertyType(apartment);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget listOfFacility() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
            width: MediaQuery.of(context).size.width,
            child: FacilitiesFilter(),
          ),
        )
      ],
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Widget listOfFurnishingItem() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        onChanged: (value) {
                          setSelectedRadio(value);
                          roomDetails.setFurnishingStatus('Fully Furnished');
                        },
                        activeColor: Colors.blue[400],
                        value: 1,
                        groupValue: selectedRadio,
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
                        onChanged: (value) {
                          setSelectedRadio(value);
                          roomDetails.setFurnishingStatus('Half Furnished');
                        },
                        activeColor: Colors.blue[400],
                        value: 2,
                        groupValue: selectedRadio,
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
                        onChanged: (value) {
                          setSelectedRadio(value);
                          roomDetails.setFurnishingStatus('Not Furnished');
                        },
                        activeColor: Colors.blue[400],
                        value: 3,
                        groupValue: selectedRadio,
                      ),
                      Text(
                        'Not Furnished',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget testFieldForMonthlyRent() {
    return Row(
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
                      onChanged: (String value) {
                        roomDetails.setMonthlyRent(value);
                      },
                      decoration: new InputDecoration(
                        hintText: roomDetails.getMonthlyRent(),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      /* onSaved: (String value) {
                        _monthly = value;
                      },*/
                      /*  validator: (value) =>
                          value.isEmpty ? 'Monthly Rent is required' : null,
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),*/
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
    );
  }

  Widget testFieldForDepositAmount() {
    return Row(
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
                      onChanged: (String value) {
                        roomDetails.setDepositAmount(value);
                      },
                      decoration: new InputDecoration(
                        hintText: roomDetails.getDepositAmout(),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      /* onSaved: (String value) {
                        _deposit = value;
                      },*/
                      /*validator: (value) =>
                          value.isEmpty ? 'Deposit Amount is required' : null,
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),*/
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
    );
  }

  Widget textField(String lebel, String hint) {
    return Row(
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
                      onChanged: (String value) {
                        switch (lebel) {
                          case "No OF MEMBERS":
                            roomDetails.setNoOfMemebers(value);
                            break;

                          case "BUILD AREA":
                            roomDetails.setbuildArea(value);
                            break;
                          case "No OF BATHROOMS":
                            roomDetails.setNoOfBathRooms(value);
                            break;
                          case "No OF BEDROOMS":
                            roomDetails.setNoOFBedRooms(value);
                            break;
                          default:
                        }
                      },
                      decoration: new InputDecoration(
                        //labelText: 'No. of Bedrooms',
                        hintText: hint,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget checkbox(String title, bool boolValue) {
    if (title == "Students" && boolValue) {
      roomDetails.setTenantType(title);
    }
    if (title == "Bachelors" && boolValue) {
      roomDetails.setTenantType(title);
    }
    if (title == "Boys Only" && boolValue) {
      roomDetails.setTenantType(title);
    }
    if (title == "Girls Only" && boolValue) {
      roomDetails.setTenantType(title);
    }
    if (title == "Anyone" && boolValue) {
      roomDetails.setTenantType(title);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: boolValue,
              onChanged: (bool value) {
                setState(() {
                  switch (title) {
                    case "Students":
                      studentVal = value;
                      break;
                    case "Bachelors":
                      bachelorsval = value;
                      break;
                    case "Boys Only":
                      boysonlyval = value;
                      break;
                    case "Girls Only":
                      girlsonlyval = value;
                      break;
                    case "Anyone":
                      anyoneval = value;
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

  checkDataBaseDataOfTenantType() {
    String tenantType = roomDetails.gettenantType();
    setState(() {
      switch (tenantType) {
        case "Students":
          studentVal = true;
          break;
        case "Bachelors":
          bachelorsval = true;
          break;
        case "Boys Only":
          boysonlyval = true;
          break;
        case "Girls Only":
          girlsonlyval = true;
          break;
        case "Anyone":
          anyoneval = true;
          break;
      }
    });
  }

  Widget buildListForTenantType() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            checkbox("Students", studentVal),
            checkbox("Bachelors", bachelorsval),
            checkbox("Boys Only", boysonlyval),
            checkbox("Girls Only", girlsonlyval),
            checkbox("Anyone", anyoneval),
          ],
        ),
      ],
    );
  }

  Widget buildCustomSizedBox() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget buildUpdateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddImage(
                          documentSnapshot: documentSnapshot,
                        )));
          },
          child: Text(
            'Edit Images',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 4.0,
          color: Colors.blue[700],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: documentSnapshot == null
          ? Loading()
          : Scaffold(
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
              body: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Container(
                        color: Colors.grey[300],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,

                        // ========== Card Widget ========

                        child: Card(
                          margin: EdgeInsets.only(
                              bottom: 100.0,
                              left: 20.0,
                              right: 20.0,
                              top: 15.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            margin: EdgeInsets.all(15.0),
                            color: Colors.white,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // ======= Adderess Text =========
                                  buildRow("ADDRESS"),

                                  // =======   State Field ======

                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        //  labelText: 'State',
                                        hintText: 'State : ' +
                                            roomDetails.getState()),
                                    onChanged: (String value) {
                                      roomDetails.setstate(value);
                                    },
                                  ),

                                  // =======   City Field ======

                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        //  labelText: 'City',
                                        hintText:
                                            'City : ' + roomDetails.getCity()),
                                    onChanged: (String value) {
                                      roomDetails.setCity(value);
                                    },
                                  ),

                                  // =======   Colony Field ======

                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        //  labelText: 'Colony',
                                        hintText: 'Colony : ' +
                                            roomDetails.getColony()),
                                    onChanged: (String value) {
                                      roomDetails.setColony(value);
                                    },
                                  ),
                                  buildCustomSizedBox(),
                                  // =======   PROPERTY TYPE  =========
                                  buildRow("PROPERTY TYPE"),
                                  // List  of Property Type
                                  listOfPropertyType(),
                                  buildCustomSizedBox(),
                                  // ========  FACILITIES  ==========
                                  buildRow("FACILITIES"),
                                  // List of Facilities type
                                  listOfFacility(),
                                  buildCustomSizedBox(),
                                  // ======== FURNISHING STATUS =======
                                  buildRow("FURNISHING STATUS"),
                                  // List of Furnishing Item
                                  listOfFurnishingItem(),
                                  buildCustomSizedBox(),
                                  // ========= MONTHLY RENT ==========
                                  buildRow("MONTHLY RENT"),
                                  //  Text Field For Monthly rent
                                  testFieldForMonthlyRent(),
                                  buildCustomSizedBox(),
                                  // ========= DEPOSIT AMOUNT ==========
                                  buildRow("DEPOSIT AMOUNT"),
                                  //  Text Field For DEPOSIT AMOUNT
                                  testFieldForDepositAmount(),
                                  buildCustomSizedBox(),
                                  // ========= No OF BEDROOMS ==========
                                  buildRow("No OF BEDROOMS"),
                                  // Text Field For No OF BEDROOMS
                                  textField("No OF BEDROOMS",
                                      roomDetails.getNoOfBedRooms()),
                                  buildCustomSizedBox(),
                                  // ========= No OF MEMBERS ==========
                                  buildRow("No OF MEMBERS"),
                                  // Text Field For No OF MEMBERS
                                  textField("No OF MEMBERS",
                                      roomDetails.getNoOfMemebers()),
                                  buildCustomSizedBox(),
                                  // ========= No OF BATHROOMS ==========
                                  buildRow("No OF BATHROOMS"),
                                  // Text Field For No OF BATHROOMS
                                  textField("No OF BATHROOMS",
                                      roomDetails.getNoOfBathRooms()),
                                  buildCustomSizedBox(),
                                  // ========= BUILD AREA ==========
                                  buildRow("BUILD AREA"),
                                  // Text Field For No OF BATHROOMS
                                  textField(
                                      "BUILD AREA", roomDetails.getBuildArea()),
                                  buildCustomSizedBox(),
                                  // ========= TYPES OF TENANT EXPECTING ==========
                                  buildRow("TYPES OF TENANT EXPECTING"),
                                  // List of checkbox for tenant type
                                  buildListForTenantType(),
                                  buildCustomSizedBox(),
                                  // ======= === Owner Details ===========
                                  buildRow("OWNER DETAILS"),

                                  //Owner Name
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        // labelText: 'Name',
                                        hintText: 'Name : ' +
                                            roomDetails.getOwnerName()),
                                    onChanged: (String value) {
                                      roomDetails.setOwnerName(value);
                                    },
                                  ),

                                  //Owner Contact Number
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        //  labelText: 'Contact No',
                                        hintText: 'Contact No : ' +
                                            roomDetails.getOwnerContactNo()),
                                    onChanged: (String value) {
                                      roomDetails.setOwnerContactNO(value);
                                    },
                                  ),

                                  //Owner Address
                                  TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                        //   labelText: 'Address',
                                        hintText: 'Address : ' +
                                            roomDetails.getOwnerAddress()),
                                    onChanged: (String value) {
                                      roomDetails.setOwnerAddress(value);
                                    },
                                  ),

                                  // Update Button
                                  buildUpdateButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class AddImage extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  AddImage({Key key, @required this.documentSnapshot}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState(documentSnapshot);
}

class _AddImageState extends State<AddImage> {
  static RoomDetails roomDetails = new RoomDetails();
  DocumentSnapshot documentSnapshot;
  _AddImageState(this.documentSnapshot);
  bool uploading = false;
  bool button = true;
  List<dynamic> imageDataPath = <dynamic>[];
  var val;
  CollectionReference imgRef;
  Future<bool> _back() {
    Navigator.pop(context);
  }

  File _image;
  final picker = ImagePicker();
  @override
  void initState() {
    imageDataPath = documentSnapshot.data['houseImages'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Add Image'),
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: GridView.builder(
                    itemCount: imageDataPath.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                          imageDataPath.removeAt(index - 1);
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
                                "UPDATE DETAILS",
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
                          UserData().updateRoomDetails(roomDetails, _userUid);
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
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    print("\nUploaded: " + url);
    setState(() {
      imageDataPath.add(url);
    });
    roomDetails.setImage(imageDataPath);
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
  List<dynamic> _filters = _EditRoomDetailsState.roomDetails.getFacilityList();

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
                //  _filters.add(actor.name);
                _EditRoomDetailsState.roomDetails
                    .getFacilityList()
                    .add(actor.name);
              } else {
                _filters.removeWhere((dynamic name) {
                  _EditRoomDetailsState.roomDetails
                      .getFacilityList()
                      .remove(actor.name);
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
          spacing: 5.0,
          runSpacing: 3.0,
          children: actorWidgets.toList(),
        ),
        Text('Look for: ${_filters.join(', ')}'),
      ],
    );
  }
}
