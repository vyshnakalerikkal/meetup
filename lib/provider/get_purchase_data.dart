import 'package:flutter/foundation.dart';
import 'package:testapp/services/firebase_api.dart';

class PurchaseProvider extends ChangeNotifier {
  String get message => _message;
  PurchaseDataStatus get status => _status;

  PurchaseDataStatus _status = PurchaseDataStatus.initilize;
  String _message = '';

  PurchaseStatus _purchaseStatus = PurchaseStatus.initilize;
  PurchaseStatus get purchaseStatus => _purchaseStatus;

  Map<String, dynamic> get userData => _userFullData;
  Map<String, dynamic> _userFullData = {};

  Future<void> postPurchaseData(Map<String, String> data) async {
    try {
      changeStatus(PurchaseStatus.loading);
      await FirbaseApi().addpurchase(data);

      changeStatus(PurchaseStatus.success);
    } catch (e) {
      _message = e.toString();
      changeStatus(PurchaseStatus.error);
    }
  }

  Future<void> getUserPurchaseRequestInfo(
      String _documentId, String purchaseDocumentId) async {
    try {
      _userFullData = await FirbaseApi()
          .getUserPurchaseData(_documentId, purchaseDocumentId);

      changePurchaseStatus(PurchaseDataStatus.success);
    } catch (e) {
      _message = e.toString();
      changePurchaseStatus(PurchaseDataStatus.error);
    }
  }

  void changePurchaseStatus(PurchaseDataStatus sts) {
    _status = sts;
    notifyListeners();
  }

  void changeStatus(PurchaseStatus sts) {
    _purchaseStatus = sts;
    notifyListeners();
  }
}

enum PurchaseDataStatus { success, error, initilize }

enum PurchaseStatus { success, error, loading, initilize }
