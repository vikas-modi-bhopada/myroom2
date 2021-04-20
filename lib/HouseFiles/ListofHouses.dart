import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:roomi/HouseFiles/editRoom.dart';
import 'package:roomi/HouseFiles/roomDetails_Page.dart';
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
  DocumentSnapshot _documentSnapshot;
  bool userAcccountPicture = false;
  List listOfAddress;

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
          searchbarData = value;
        },
      ),
    );
  }

  Widget roomList() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: listViewForRoomList(),
    ));
  }

  ListView listViewForRoomList() {
    if (querySnapshot != null) {
      print(querySnapshot.documents.length);
      return ListView.separated(
          itemBuilder: (context, index) {
            _documentSnapshot = querySnapshot.documents[index];
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HouseDetail(
                          index: index,
                        ),
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

  firstRowOfListView(int index) {
    listOfAddress = querySnapshot.documents[index].data["Address"];
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Stack(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            borderOnForeground: true,
            child: InkWell(
              onTap: () {
                // Navigate
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HouseDetail(
                      index: index,
                    ),
                  ),
                );
              },
              child: Column(children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.grey,
                    child: Image.network(
                        querySnapshot.documents[index].data['houseImages'][0],
                        fit: BoxFit.fill),
                  ),
                ),
                Row(children: <Widget>[
                  ResponsiveContainer(
                    widthPercent: 23,
                    heightPercent: 9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: _documentSnapshot.data['Overview']
                                        ['propertyType'] !=
                                    'Room'
                                ? Text(
                                    '${_documentSnapshot.data['builtUpArea']} Sq.ft.')
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          'For ${_documentSnapshot.data['Members']} '),
                                      Text(' Members'),
                                    ],
                                  )),
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 41,
                    heightPercent: 9,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          _documentSnapshot.data['Overview']['propertyType'] !=
                                  "Room"
                              ? Column(
                                  children: [
                                    Align(
                                        child: Text(
                                            '${_documentSnapshot['Overview']['room']} BHK in ${listOfAddress.elementAt(2)}')),
                                    Align(
                                        child: Text(
                                            '${_documentSnapshot['Overview']['furnishingStatus']}')),
                                  ],
                                )
                              : Text(listOfAddress.elementAt(2) +
                                      " , " +
                                      listOfAddress.elementAt(3) +
                                      " , "
                                  //'${_documentSnapshot['Address']['society']},${_documentSnapshot['Address']['city']}'
                                  ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 23,
                    heightPercent: 9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(10)),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.rupeeSign,
                                    size: 13,
                                  ),
                                  Text(
                                      '${_documentSnapshot.data['monthlyRent']} /-'),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text('Month'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ]),
            ),
          ),
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Center(
                    child: Text(
                  "${_documentSnapshot.data['Overview']['propertyType']}",
                  style: TextStyle(color: Colors.deepOrange),
                )),
                color: Colors.white,
              ),
            ),
            top: 4,
            left: 20,
          )
        ],
      )
    ]);
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) {
      _email = value.email;
      _username = value.displayName;
    });
    UserData().refreshList().then((QuerySnapshot results) {
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
              SizedBox(
                height: 10,
              ),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddHouse()));
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditRoom()));
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
