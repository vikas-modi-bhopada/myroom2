import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomi/Widget/bezierContainer.dart';

class UploadRoomDetails extends StatefulWidget {
  @override
  _UploadRoomDetailsState createState() => _UploadRoomDetailsState();
}

class _UploadRoomDetailsState extends State<UploadRoomDetails> {
  var location;
  var price;
  var members;
  var beds;
  var phoneNo;
  var bathroom;
  File _image;
  File _image2;
  String imageURI;
  final picker = ImagePicker();
  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() => _image = File(pickedFile.path));
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
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
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              beds = val;
            },
          )
        ],
      ),
    );
  }

  _uplodDetails(String _location, String _price, String _members, String _beds,
      String _bathroom, String _phoneNo) {
    Firestore.instance
        .collection("RoomDetails")
        .add({
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
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
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
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

  Widget _uploadRoomImage() {
    return Container(
      child: Row(
        children: [
          expandedWidgetForFirstRoomImage(),
          expandedWIdgetForSecondRoomImage(),
        ],
      ),
    );
  }

  Expanded expandedWIdgetForSecondRoomImage() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          padding: EdgeInsets.all(8),
          decoration: myBoxDecoration(),
          child: _image == null
              ? Icon(Icons.upload_file, size: 50, color: Colors.blueGrey)
              : Image.file(_image),
        ),
      ),
    );
  }

  Expanded expandedWidgetForFirstRoomImage() {
    return Expanded(
        child: GestureDetector(
      onTap: () async {
        final pickedFile1 = await picker.getImage(source: ImageSource.camera);
        setState(() => _image2 = File(pickedFile1.path));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        padding: EdgeInsets.all(8),
        decoration: myBoxDecoration(),
        child: _image == null
            ? Icon(Icons.upload_file, size: 50, color: Colors.blueGrey)
            : Image.file(_image),
      ),
    ));
  }

  Widget _saveDetailsButton() {
    return InkWell(
      onTap: () {
        _uplodDetails(location, price, members, beds, bathroom, phoneNo);
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
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
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
                  _uploadRoomImage(),
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
