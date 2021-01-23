import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  Future<QuerySnapshot> getData(dynamic searchbarData) async {
    return await Firestore.instance
        .collection("RoomDetails")
        .where('Location', isEqualTo: searchbarData)
        .getDocuments();
  }

  Future<QuerySnapshot> getData1() async {
    return await Firestore.instance.collection("RoomDetails").getDocuments();
  }
}
