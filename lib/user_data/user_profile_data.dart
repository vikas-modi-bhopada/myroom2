import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  Future<QuerySnapshot> getData(dynamic searchbarData) async {
    return await Firestore.instance
        .collection("RoomDetails")
        .where('Location', isEqualTo: searchbarData)
        .getDocuments();
  }

  Future<QuerySnapshot> refreshList() async {
    return await Firestore.instance.collection("RoomDetails").getDocuments();
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
    String imageUrl1,
    String imageUrl2,
    String imageUrl3,
    String imageUrl4,
  ) {
    Firestore.instance.collection("RoomDetails").document(docId).updateData({
      "Location": location,
      "Price": price,
      "Members": members,
      "Beds": beds,
      "BathRooms": bathroom,
      "Mobile": phoneNo,
      "image1": imageUrl1,
      "image2": imageUrl2,
      "image3": imageUrl3,
      "image4": imageUrl4,
    });
  }

  deleteUserAccountInformation() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String str = user.uid;

    Firestore.instance.collection("users").document(str).delete();
    Firestore.instance.collection("RoomDetails").document(str).delete();
  }
}
