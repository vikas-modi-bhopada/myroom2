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

  updateDetails(
      String docId,
      String location,
      String price,
      String members,
      String beds,
      String bathroom,
      String phoneNo,
      String img1,
      String img2,
      String img3,
      String img4) {
    Firestore.instance.collection("RoomDetails").document(docId).updateData({
      "Location": location,
      "Price": price,
      "Members": members,
      "Beds": beds,
      "BathRooms": bathroom,
      "Mobile": phoneNo,
      "image1": img1,
      "image2": img2,
      "image3": img3,
      "image4": img4,
    });
  }
}
