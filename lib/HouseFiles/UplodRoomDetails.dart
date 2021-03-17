import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomi/HouseFiles/ListofHouses.dart';
import 'package:roomi/Shared/loadingwidget.dart';
import 'package:roomi/Widget/bezierContainer.dart';

class UploadRoomDetails extends StatefulWidget {
  @override
  _UploadRoomDetailsState createState() => _UploadRoomDetailsState();
}

class _UploadRoomDetailsState extends State<UploadRoomDetails> {
  String location;
  var price;
  var members;
  var beds;
  String _email;
  var phoneNo;
  var bathroom;
  String userId;
  File image1, image2, image3, image4;
  String imageURI;

  var i = 1;

  @override
  Future<String> uploadFile(File _image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('$_email/image_NO_$i');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    i = i + 1;
    return returnURL;
  }

  final picker = ImagePicker();

  Future _imgFromCamera(i) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (i == 1) {
      setState(() => image1 = File(pickedFile.path));
    }
    if (i == 2) {
      setState(() => image2 = File(pickedFile.path));
    }
    if (i == 3) {
      setState(() => image3 = File(pickedFile.path));
    }
    if (i == 4) {
      setState(() => image4 = File(pickedFile.path));
    }
  }

  _imgFromGallery(i) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (i == 1) {
      setState(() => image1 = File(pickedFile.path));
    }
    if (i == 2) {
      setState(() => image2 = File(pickedFile.path));
    }
    if (i == 3) {
      setState(() => image3 = File(pickedFile.path));
    }
    if (i == 4) {
      setState(() => image4 = File(pickedFile.path));
    }
  }

  void _showPicker(context, i) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _imgFromGallery(i);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(i);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  GestureDetector listOFimages(i) {
    File x;
    if (i == 1) x = image1;
    if (i == 2) x = image2;
    if (i == 3) x = image3;
    if (i == 4) x = image4;
    return GestureDetector(
      onTap: () {
        _showPicker(context, i);
      },
      child: Container(
        width: 120,
        child: Card(
          child: Stack(
            children: <Widget>[
              Center(
                child: x == null
                    ? Icon(Icons.image, size: 50, color: Colors.blueGrey)
                    : Image.file(x),
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
                      if (i == 1) image1 = null;
                      if (i == 2) image2 = null;
                      if (i == 3) image3 = null;
                      if (i == 4) image4 = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: deprecated_member_use

  Widget buildGridViewForImages() {
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          listOFimages(1),
          listOFimages(2),
          listOFimages(3),
          listOFimages(4)
        ],
      ),
    );
  }

  Widget _locationlabel(String data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true,
                hintText: 'Location'),
                keyboardType: TextInputType.text,
            onChanged: (val) {
              location = val;
            },
          )
        ],
      ),
    );
  }

  Widget _pricelabel(String data) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true,
                hintText: 'Price per month'
                ),
           keyboardType: TextInputType.number,
           
            onChanged: (val) {
              price = val;
            },
          )
        ],
      ),
    );
  }

  Widget _memberslabel(String data) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Number of members',
                 fillColor: Colors.grey, filled: true),
           keyboardType: TextInputType.number,
            onChanged: (val) {
              members = val;
            },
          )
        ],
      ),
    );
  }

  Widget _bedslabel(String data) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, 
                hintText: 'Number of beds',
                fillColor: Colors.grey, filled: true),
           keyboardType: TextInputType.number,
            onChanged: (val) {
              beds = val;
            },
          )
        ],
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  _uplodDetails(String _location, String _price, String _members, String _beds,
      String _bathroom, String _phoneNo) async {
    String imageURL1 = await uploadFile(image1);
    String imageURL2 = await uploadFile(image2);
    String imageURL3 = await uploadFile(image3);
    String imageURL4 = await uploadFile(image4);
    Firestore.instance
        .collection("RoomDetails")
        .document(userId)
        .setData({
          "image1": imageURL1,
          "image2": imageURL2,
          "image3": imageURL3,
          "image4": imageURL4,
          'Location': _location,
          'Price': _price,
          'Members': _members,
          'BathRooms': _bathroom,
          'Beds': _beds,
          'Mobile': _phoneNo
        })
        .then((value) => print('User information added'))
        .catchError((e) => print('Failed to add user information'));
  }

  Widget _bathroomslabel(String data) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Number of bathrooms',
                 fillColor: Colors.grey, filled: true),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              bathroom = val;
            },
          )
        ],
      ),
    );
  }

  Widget _residence() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _memberslabel("Members")),
          SizedBox(
            width: 50,
          ),
          Expanded(child: _bedslabel("Beds")),
          SizedBox(
            width: 50,
          ),
          Expanded(child: _bathroomslabel("Bathrooms")),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'R',
          style: GoogleFonts.portLligatSans(
              // ignore: deprecated_member_use
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'oo',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'mi',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _phonenumber(String data) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, 
                hintText: 'Phone number',
                fillColor: Colors.grey, filled: true),
          keyboardType: TextInputType.phone,
          maxLength: 10,
            onChanged: (val) {
              phoneNo = val;
            },
          )
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.0)));
  }

  Widget _saveDetailsButton() {
    return InkWell(
      onTap: () {
        Loading();
        _uplodDetails(
            location.toUpperCase(), price, members, beds, bathroom, phoneNo);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListOfHouse()));
        // UserData().getData();
      } //UserData().onPressed(),
      ,
      child: containerOfInkWellOfSaveDetailsButton(),
    );
  }

  Container containerOfInkWellOfSaveDetailsButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: boxDecorationWidgetForContainerOfSaveButton(),
      child: Text(
        'Save',
        style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
      ),
    );
  }

  BoxDecoration boxDecorationWidgetForContainerOfSaveButton() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xffdf8e33).withAlpha(100),
              offset: Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 2)
        ],
        color: Colors.white);
  }

  
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      userId = value.uid;
      _email = value.email;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          height: height,
          child: buildStackForChildOfContainerOfBuildWidget(height, context)),
    );
  }

  Stack buildStackForChildOfContainerOfBuildWidget(
      double height, BuildContext context) {
    return Stack(
      children: [
        buildPositionedWidgetForBezierContainer(height, context),
        Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  _title(),
                  SizedBox(
                    height: 5,
                  ),
                  _locationlabel("Location"),
                  SizedBox(
                    height: 15,
                  ),
                  _pricelabel("Price"),
                  SizedBox(
                    height: 15,
                  ),
                  _residence(),
                  SizedBox(
                    height: 15,
                  ),
                  _phonenumber("Phone Number"),
                  SizedBox(
                    height: 15,
                  ),
                  buildGridViewForImages(),
                  SizedBox(
                    height: 15,
                  ),
                  _saveDetailsButton()
                ],
              )),
        )
      ],
    );
  }

  Positioned buildPositionedWidgetForBezierContainer(
      double height, BuildContext context) {
    return Positioned(
        top: -height * .15,
        right: -MediaQuery.of(context).size.width * .4,
        child: BezierContainer());
  }
}
