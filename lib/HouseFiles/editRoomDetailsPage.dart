import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomi/HouseFiles/ListofHouses.dart';
import 'package:roomi/Widget/bezierContainer.dart';
import 'package:roomi/user_data/user_profile_data.dart';

class EditRoomDetails extends StatefulWidget {
  @override
  _EditRoomDetailsState createState() => _EditRoomDetailsState();
}

class _EditRoomDetailsState extends State<EditRoomDetails> {
  String location;
  String price;
  String members;
  String beds;
  String phoneNo;
  String bathroom;
  String userId;
  String imageUrl1, imageUrl2, imageUrl3, imageUrl4;
  DocumentSnapshot documentSnapshot;
  File image1, image2, image3, image4;
  String imageURI;
  // ignore: deprecated_member_use
  List<File> images = List<File>();
  //var i = 1;

  Future<String> uploadFile(File _image, int i) async {
    print("inside uplodefile $i");
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('image_NO_$i');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    // i = i + 1;
    return returnURL;
  }

  final picker = ImagePicker();
  Future _imgFromCamera(i) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (i == 1) {
      setState(() async {
        image1 = File(pickedFile.path);
        imageUrl1 = await uploadFile(image1, i);
        setState(() {});
      });
    }
    if (i == 2) {
      // setState(() => image2 = File(pickedFile.path));
      setState(() async {
        image2 = File(pickedFile.path);
        imageUrl2 = await uploadFile(image2, i);
        setState(() {});
      });
    }
    if (i == 3) {
      // setState(() => image3 = File(pickedFile.path));
      setState(() async {
        image3 = File(pickedFile.path);
        imageUrl3 = await uploadFile(image3, i);
        setState(() {});
      });
    }
    if (i == 4) {
      setState(() async {
        image4 = File(pickedFile.path);
        imageUrl4 = await uploadFile(image4, i);
        setState(() {});
      });
      //setState(() => image4 = File(pickedFile.path));
    }
  }

  _imgFromGallery(i) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (i == 1) {
      setState(() async {
        image1 = File(pickedFile.path);
        imageUrl1 = await uploadFile(image1, i);
        setState(() {});
      });
    }
    if (i == 2) {
      // setState(() => image2 = File(pickedFile.path));
      setState(() async {
        image2 = File(pickedFile.path);
        imageUrl2 = await uploadFile(image2, i);
        setState(() {});
      });
    }
    if (i == 3) {
      // setState(() => image3 = File(pickedFile.path));
      setState(() async {
        image3 = File(pickedFile.path);
        imageUrl3 = await uploadFile(image3, i);
        setState(() {});
      });
    }
    if (i == 4) {
      setState(() async {
        image4 = File(pickedFile.path);
        imageUrl4 = await uploadFile(image4, i);
        setState(() {});
      });
      //setState(() => image4 = File(pickedFile.path));
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
                      onTap: () {
                        _imgFromGallery(i);
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
    String str;
    switch (i) {
      case 1:
        str = imageUrl1;
        break;
      case 2:
        str = imageUrl2;
        break;
      case 3:
        str = imageUrl3;
        break;
      case 4:
        str = imageUrl4;
        break;
    }
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
                child: Image.network(str),
                /* child: x == null
                      ? Icon(Icons.image, size: 50, color: Colors.blueGrey)
                      : Image.file(x),*/
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
                  onTap: () {},
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
    if (documentSnapshot != null) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(
                location,
              ),
            )
            /* TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              location = val;
            },
          )*/
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
          GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(price)),
          /*(TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              price = val;
            },
          )*/
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
          GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(members)),
          /*TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              members = val;
            },
          )*/
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
          GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(beds)),
          /*TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              beds = val;
            },
          )*/
        ],
      ),
    );
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
          GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(bathroom)),
          /*TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              bathroom = val;
            },
          )*/
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
          GestureDetector(
              onTap: () {
                showDialogForMessage(data);
              },
              child: Text(phoneNo)),
          /*TextField(
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey, filled: true),
            onChanged: (val) {
              phoneNo = val;
            },
          )*/
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

  showDialogForMessage(String title) {
    TextEditingController customeController = TextEditingController();
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          if (customeController.text.toString().isNotEmpty) {
            switch (title) {
              case "Location":
                location = customeController.text.toString();
                break;
              case "Members":
                members = customeController.text.toString();
                break;
              case "Price":
                price = customeController.text.toString();
                break;
              case "Beds":
                beds = customeController.text.toString();
                break;
              case "Bathrooms":
                bathroom = customeController.text.toString();
                break;
              case "Phone Number":
                phoneNo = customeController.text.toString();
                break;
            }
          }

          Navigator.of(context).pop();
          setState(() {});
        });

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: TextField(
        controller: customeController,
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget _saveDetailsButton() {
    return InkWell(
      onTap: () async {
        print("Inside _saveDetailsButton");
        // String imageURL1 = await uploadFile(image1);
        // String imageURL2 = await uploadFile(image2);
        // String imageURL3 = await uploadFile(image3);
        // String imageURL4 = await uploadFile(image4);
        UserData().updateDetails(userId, location, price, members, beds,
            bathroom, phoneNo, imageUrl1, imageUrl2, imageUrl3, imageUrl4);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ListOfHouse()));
        //_uplodDetails(location, price, members, beds, bathroom, phoneNo);
      },
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
      setState(() {
        UserData()
            .getPerticularRoomDetails(userId)
            .then((DocumentSnapshot value) {
          setState(() {
            documentSnapshot = value;
            location = value.data["Location"];
            bathroom = value.data["BathRooms"];
            beds = value.data["Beds"];
            members = value.data["Members"];
            phoneNo = value.data["Mobile"];
            price = value.data["Price"];
            imageUrl1 = value.data["image1"];
            imageUrl2 = value.data["image2"];
            imageUrl3 = value.data["image3"];
            imageUrl4 = value.data["image4"];
          });
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (documentSnapshot != null) {
      final height = MediaQuery.of(context).size.height;
      return Scaffold(
        body: Container(
            height: height,
            child: buildStackForChildOfContainerOfBuildWidget(height, context)),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
