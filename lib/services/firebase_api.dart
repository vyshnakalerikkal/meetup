import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testapp/model/userModel.dart';

class FirbaseApi {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> createUser(Map<String, String> data) async {
    try {
      await _fireStore.collection('users').doc(data['mobile']).set({
        'name': data['name'],
        'dob': data['dob'],
        'gender': data['gender'],
        'location': data['location'],
        'mobile': data['mobile'],
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserData(String documentId) async {
    try {
      DocumentSnapshot ref =
          await _fireStore.collection("users").doc(documentId).get();

      final _data = ref.data() as Map<String, dynamic>;

      return _data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUser(Map<String, String> data) async {
    try {
      await _fireStore.collection('users').doc(data['mobile']).update({
        'image': data['image'],
        'about': data['about'],
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<UserModel>> getUserList(String documentId) async {
    List<UserModel> userList = [];

    try {
      final QuerySnapshot res = await _fireStore.collection('users').get();

      res.docs.forEach(
        (element) {
          userList.add(
            UserModel.fromJson(
              element.data() as Map<String, dynamic>,
            ),
          );
        },
      );
      userList.removeWhere((element) => element.mobile == documentId);
      return userList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addpurchase(Map<String, String> data) async {
    try {
      await _fireStore.collection('purchase').doc().set({
        'documentId': data['documentId'],
        'purchasedDocumentId': data['purchasedDocumentId'],
        'requestStatus': '0',
        
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}