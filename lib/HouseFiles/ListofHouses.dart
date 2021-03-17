import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomi/HouseFiles/editRoomDetailsPage.dart';
import 'package:roomi/HouseFiles/listOfRoomImages.dart';
import 'package:roomi/Shared/loadingwidget.dart';
import 'package:roomi/controllers/authentications.dart';
import 'package:roomi/loginPage.dart';
import 'package:roomi/user_data/user_profile_data.dart';
import 'package:roomi/welcomePage.dart';

import 'UplodRoomDetails.dart';

class ListOfHouse extends StatefulWidget {
  @override
  _ListOfHouseState createState() => _ListOfHouseState();
}

class _ListOfHouseState extends State<ListOfHouse> {
  UserData userData = new UserData();
  QuerySnapshot querySnapshot;
  QuerySnapshot querySnapshot1;
  bool userAcccountPicture = false;

  var _email;
  var _username;
  var searchbarData;
  bool _dataFound = true;

  Widget profilePicture() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.green,
              ),
              onPressed: () {}),
          CircleAvatar(
            child: ClipRRect(
              child: Image.asset('assets/images/splash_screen.png'),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          )
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          UserData().getData(searchbarData).then((QuerySnapshot results) {
            if (results.documents.isEmpty) {
              _dataFound = false;
            } else {
              _dataFound = true;
            }

            setState(() {
              querySnapshot = results;
            });
          });
        },
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green[300]),
            ),
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.grey[500],
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                UserData().getData(searchbarData).then((QuerySnapshot results) {
                  if (results.documents.isEmpty) {
                    _dataFound = false;
                  } else {
                    _dataFound = true;
                  }

                  setState(() {
                    querySnapshot = results;
                  });
                });
              },
            ),
            hintText: "Search Location",
            focusColor: Colors.green),
        onChanged: (value) {
          searchbarData = value.toUpperCase();
        },
      ),
    );
  }

  Widget roomList() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      color: Colors.grey[100],
      child: listViewForRoomList(),
    ));
  }

  ListView listViewForRoomList() {
    if (querySnapshot != null) {
      print(querySnapshot.documents.length);
      return ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  print(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListOfRoomImages(index1: index),
                        //settings: RouteSettings(arguments: index),
                      ));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    firstRowOfListView(index),
                    SizedBox(
                      height: 12,
                    ),
                    secondRowOfListView(index),
                    SizedBox(
                      height: 16,
                    ),
                    thirdRowOfListView(index)
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: querySnapshot.documents.length);
    } else {
      print("query snapshot is null");
      return null;
    }
  }

  Container thirdRowOfListView(int index) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 16),
      child: Row(
        children: [
          Icon(
            Icons.phone,
            size: 12,
            color: Colors.grey[600],
          ),
          Text(
            querySnapshot.documents[index].data['Mobile'],
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  Container secondRowOfListView(int index) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rowWidgetForNoOfPeople(index),
          rowWidgetForNoOfBeds(index),
          rowWidgetForNoOfBathRooms(index)
        ],
      ),
    );
  }

  Row rowWidgetForNoOfBathRooms(int index) {
    return Row(
      children: [
        Icon(
          Icons.airline_seat_legroom_reduced,
          size: 12,
          color: Colors.grey[600],
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          querySnapshot.documents[index].data['BathRooms'],
          style: TextStyle(color: Colors.grey[600]),
        )
      ],
    );
  }

  Row rowWidgetForNoOfBeds(int index) {
    return Row(
      children: [
        Icon(
          Icons.local_offer,
          size: 12,
          color: Colors.grey[600],
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          querySnapshot.documents[index].data['Beds'],
          style: TextStyle(color: Colors.grey[600]),
        )
      ],
    );
  }

  Row rowWidgetForNoOfPeople(int index) {
    return Row(
      children: [
        Icon(
          Icons.people,
          size: 12,
          color: Colors.grey[600],
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          querySnapshot.documents[index].data['Members'],
          style: TextStyle(color: Colors.grey[600]),
        )
      ],
    );
  }

  Row firstRowOfListView(int index) {
    return Row(
      children: [
        containerOfImageOfRoomInListView(index),
        SizedBox(
          width: 20,
        ),
        widgetForLocationAndPrice(index),
        IconButton(icon: Icon(Icons.navigation), onPressed: () {})
      ],
    );
  }

  Container containerOfImageOfRoomInListView(int index) {
    return Container(
      width: 90,
      height: 90,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              child: GestureDetector(
          child: ClipOval(
            child: Image.network(
              querySnapshot.documents[index].data['image1'],
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListOfRoomImages(index1: index),
                ));
          },
        ),
      ),
    );
  }

  Expanded widgetForLocationAndPrice(int index) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidgetForLocation(index),
        SizedBox(
          height: 8,
        ),
        textWidgetForPriceOfRoom(index)
      ],
    ));
  }

  Text textWidgetForPriceOfRoom(int index) {
    return Text(
      querySnapshot.documents[index].data['Price'],
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Text textWidgetForLocation(int index) {
    return Text(
      querySnapshot.documents[index].data['Location'],
      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      _email = value.email;
      _username = value.displayName;
    });
    UserData().getData(searchbarData).then((QuerySnapshot results) {
      setState(() {
        querySnapshot = results;
      });
    });
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you really want to exit the app ?"),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No")),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes"))
              ],
            ));
  }

  Widget noDataFoundWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('assets/images/nodatafound.jpg'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (querySnapshot != null) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: buildAppBarForBuildWidget(),
          drawer: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: sideNav()),
          // body: _userdataWidget(),
          body: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              searchBar(),
              _dataFound ? roomList() : noDataFoundWidget()
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Loading(),
      );
    }
  }

  AppBar buildAppBarForBuildWidget() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh_outlined,
            color: Colors.white,
          ),
          tooltip: "Refresh",
          onPressed: () {
            UserData().refreshList().then((QuerySnapshot results) {
              if (results.documents.isEmpty) {
                _dataFound = false;
              } else {
                _dataFound = true;
              }

              setState(() {
                querySnapshot = results;
              });
            });
          },
        ),
      ],
      elevation: 10.0,
      centerTitle: true,
      title: Text("Roomi"),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xfffbb448), Color(0xffe46b10)])),
      ),
    );
  }

  Drawer sideNav() {
    return Drawer(
        child: Stack(children: <Widget>[
      //first child be the blur background
      backdropFilterWidgetForDrawer(),
      listViewOfDrawer()
    ]));
  }

  ListView listViewOfDrawer() {
    return ListView(padding: EdgeInsets.zero, children: <Widget>[
      userAccountsDrawerHeader(),
      Divider(
        thickness: .5,
        endIndent: 40,
        indent: 40,
        color: Colors.white,
      ),
      uploadRoomDetailsListTileForDrawer(),
      Divider(
        thickness: .5,
        endIndent: 40,
        indent: 40,
        color: Colors.white,
      ),
      editRoomDetailsListTileForDrawer(),
      Divider(
        thickness: .5,
        endIndent: 40,
        indent: 40,
        color: Colors.white,
      ),
      logOutListTileForDrawer(),
      Divider(
        thickness: .5,
        endIndent: 40,
        indent: 40,
        color: Colors.white,
      ),
      deleteAccountListTileForDrawer(),
      Divider(
        thickness: .5,
        endIndent: 40,
        indent: 40,
        color: Colors.white,
      ),
    ]);
  }

  ListTile logOutListTileForDrawer() {
    return ListTile(
        title: Text(
          "Log Out",
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.logout,
          color: Colors.orange,
        ),
        onTap: () {
          Navigator.pop(context);
          signOutUser();
          FirebaseAuth.instance.onAuthStateChanged.listen((user) {
            if (user == null) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            } else {
              print("User is not signout");
            }
          });
        });
  }

  ListTile uploadRoomDetailsListTileForDrawer() {
    return ListTile(
      title: Text(
        "Upload Room Details",
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.upload_file,
        color: Colors.orange,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UploadRoomDetails()));
      },
    );
  }

  ListTile editRoomDetailsListTileForDrawer() {
    return ListTile(
      title: Text(
        "Edit Room Details",
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.edit,
        color: Colors.orange,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditRoomDetails()));
      },
    );
  }

  ListTile deleteAccountListTileForDrawer() {
    return ListTile(
      title: Text(
        "Delete Account",
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        Icons.delete,
        color: Colors.orange,
      ),
      onTap: () {
        Navigator.pop(context);
        UserData().deleteUserAccountInformation();
        deleteAccount();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
  }

  UserAccountsDrawerHeader userAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      currentAccountPicture: userAcccountPicture
          ? CircleAvatar(
              child: ClipRRect(
                child: Image.asset('assets/images/splash_screen.png'),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
      accountName: Text('Name  : $_username'),

      //Text('$_username'),
      accountEmail: Text('Email  : $_email'),
    );
  }

  BackdropFilter backdropFilterWidgetForDrawer() {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        //this is dependent on the import statment above
        child: Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5))));
  }
}
