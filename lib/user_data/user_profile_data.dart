import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  Future<QuerySnapshot> getData(dynamic searchbarData) async {
    return await Firestore.instance
        .collection("RoomDetails")
        .where('Location', isEqualTo: searchbarData)
        .getDocuments();
  }

  Future<DocumentSnapshot> getPerticularRoomDetails(String docId) async {
    return await Firestore.instance
        .collection("RoomDetails")
        .document(docId)
        .get();
  }

  updateDetails(String docId, String location, String price, String members,
      String beds, String bathroom, String phoneNo) {
    Firestore.instance.collection("RoomDetails").document(docId).updateData({
      "Location": location,
      "Price": price,
      "Members": members,
      "Beds": beds,
      "BathRooms": bathroom,
      "Mobile": phoneNo
    });
  }
}
