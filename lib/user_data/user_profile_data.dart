import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roomi/HouseFiles/roomDetails.dart';

class UserData {
  Future<QuerySnapshot> getData(dynamic searchbarData) async {
    List searchLocationList = searchbarData.toString().split(' ');
    print(searchLocationList);
    return await Firestore.instance
        .collection("RoomDetails")
        .where("Address", arrayContainsAny: searchLocationList)
        // .where('Location', isEqualTo: searchbarData)
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

  /*updateRoomDetails(RoomDetails roomDetails, String userUid) {
    print(roomDetails.getMapOfAddress(roomDetails));
    Firestore.instance.collection('RoomDetails').document(userUid).updateData({
      "Address": roomDetails.getMapOfAddress(roomDetails),
      "Facilities": roomDetails.getFacilityList(),
      "Members": roomDetails.getNoOfMemebers(),
      "Overview": roomDetails.getMapOfOverView(roomDetails),
      "OwnerAdd": roomDetails.getOwnerAddress(),
      "OwnerName": roomDetails.getOwnerName(),
      "OwnerPhone": roomDetails.getOwnerContactNo(),
      "builtUpArea": roomDetails.getBuildArea(),
      "depositAmount": roomDetails.getDepositAmout(),
      "monthlyRent": roomDetails.getMonthlyRent(),
    });
  }*/

  deleteUserAccountInformation() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String str = user.uid;

    Firestore.instance.collection("users").document(str).delete();
    Firestore.instance.collection("RoomDetails").document(str).delete();
  }
}
