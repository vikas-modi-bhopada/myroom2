import 'package:flutter/material.dart';
import 'package:roomi/user_data/user_profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ListOfRoomImages extends StatefulWidget {
  int index1;
  ListOfRoomImages({Key key, @required this.index1}) : super(key: key);

  @override
  _ListOfRoomImagesState createState() => _ListOfRoomImagesState(index1);
}

class _ListOfRoomImagesState extends State<ListOfRoomImages> {
  int index1;
  QuerySnapshot querySnapshot;
  var searchbarData;

  _ListOfRoomImagesState(this.index1);

  @override
  void initState() {
    UserData().getData(searchbarData).then((QuerySnapshot results) {
      setState(() {
        querySnapshot = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final String str = ModalRoute.of(context).settings.arguments;
    if (querySnapshot != null) {
      var height = MediaQuery.of(context).size.height;
      return Container(
        height: height,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            Image.network(
                querySnapshot.documents[index1].data['image' + (1).toString()]),
            Image.network(
                querySnapshot.documents[index1].data['image' + (2).toString()]),
            Image.network(
                querySnapshot.documents[index1].data['image' + (3).toString()]),
            Image.network(
                querySnapshot.documents[index1].data['image' + (4).toString()])
          ],
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 4.0,
          indicatorBgPadding: 2.0,
        ),
      );

      /* ListView.separated(
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(querySnapshot
                  .documents[index1].data['image' + (index + 1).toString()]),
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: 4,
      );*/
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
