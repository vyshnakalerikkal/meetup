import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testapp/model/message.dart';
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
    List<String> purchaseIds = [];

    purchaseIds = await getPurchaseList(documentId);

    try {
      final QuerySnapshot res = await _fireStore.collection('users').get();

      res.docs.forEach(
        (element) {
          userList.add(
            UserModel.fromJson(element.data() as Map<String, dynamic>,
                purchaseIds.contains(element.get('mobile')) ? 1 : 0),
          );
        },
      );
      userList.removeWhere((element) => element.mobile == documentId);
      return userList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<String>> getPurchaseList(String documentId) async {
    List<String> list = [];

    try {
      final QuerySnapshot res = await _fireStore
          .collection('purchase')
          .where('documentId', isEqualTo: documentId)
          .get();

      res.docs.forEach(
        (element) {
          list.add(element.get('purchasedDocumentId'));
        },
      );

      return list;
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

  Future<Map<String, dynamic>> getUserPurchaseData(
      String documentId, String purchaseDocumentId) async {
    try {
      Map<String, dynamic> _data = {};
      final QuerySnapshot res = await _fireStore
          .collection('purchase')
          .where('documentId', isEqualTo: documentId)
          .where('purchasedDocumentId', isEqualTo: purchaseDocumentId)
          .get();

      res.docs.forEach(
        (element) {
          _data = element.data() as Map<String, dynamic>;
        },
      );

      return _data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<UserModel>> getRequestUserList(String documentId) async {
    List<String> list = [];

    try {
      final QuerySnapshot res = await _fireStore
          .collection('purchase')
          .where('purchasedDocumentId', isEqualTo: documentId)
          .where('requestStatus', isEqualTo: '1')
          .get();

      res.docs.forEach(
        (element) {
          list.add(element.get('documentId'));
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }

    List<UserModel> userList = [];

    try {
      final QuerySnapshot res = await _fireStore.collection('users').get();

      res.docs.forEach(
        (element) {
          if (list.contains(element.get('mobile'))) {
            userList.add(UserModel.fromJson(
              element.data() as Map<String, dynamic>,
              1,
            ));
          }
        },
      );
      userList.removeWhere((element) => element.mobile == documentId);
      return userList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserRequest(Map<String, String> data) async {
    try {
      final QuerySnapshot res = await _fireStore
          .collection('purchase')
          .where(
            'documentId',
            isEqualTo: data['documentId'],
          )
          .where('purchasedDocumentId', isEqualTo: data['purchasedDocumentId'])
          .where('requestStatus', isEqualTo: data['currentStatus'])
          .get();

      res.docs.forEach(
        (element) {
          _fireStore.collection('purchase').doc(element.id).update({
            'requestStatus': data['requestStatus'],
          });
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future uploadMessage(
      String idUser, String message, Map<String, dynamic> data) async {
    final refMessages = _fireStore
        .collection('chats')
        .doc(data['mobile'])
        .collection('messages');

    final newMessage = Message(
      idUser: data['mobile'],
      urlAvatar: data['image'],
      username: data['name'],
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
  }

  Stream<QuerySnapshot> getChatMessage(String idUser) {
    return _fireStore
        .collection('chats')
        .doc(idUser)
        .collection('messages')
        .orderBy(MessageField.createdAt, descending: true)
        .snapshots();
  }
}
