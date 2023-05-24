
import 'package:cloud_firestore/cloud_firestore.dart';



class FirbaseApi {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> createUser(Map<String,String> data) async {
    try {
      await _fireStore
          .collection('users')
          .doc(data['mobile'])
          .set({'name': data['name'], 'dob': data['dob'],'gender':data['gender'],'location':data['location'],'mobile': data['mobile'], 'created_at': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  

//   // ignore: missing_return
//   Future<List<CrewModel>> getCrewList(FilterParam filter) async {
//     List<CrewModel> crewList = [];

//     try {
//       final QuerySnapshot res = await _fireStore
//           .collection('crews')
//           .where('role_id', isEqualTo: filter.roleId)
//           .where('film_industry', isEqualTo: filter.filmIndustry)
//           .limit(10)
//           .get();

//       res.docs.forEach(
//         (element) {
//           crewList.add(
//             CrewModel.fromJson(
//               element.data() as Map<String, dynamic>,
//               element,
//             ),
//           );
//         },
//       );
//       return crewList;
//     } catch (e) {
//       print(e);
//       throw Exception(e.toString());
//     }
//   }

//   // ignore: missing_return
//   Future<List<CrewModel>> getNextcrew(FilterParam filter, DocumentSnapshot lastDoc) async {
//     List<CrewModel> crewList = [];
//     try {
//       final QuerySnapshot res = await _fireStore
//           .collection('crews')
//           .where('role_id', isEqualTo: filter.roleId)
//           .where('film_industry', isEqualTo: filter.filmIndustry)
//           .startAfterDocument(lastDoc)
//           .limit(10)
//           .get();

//       res.docs.forEach(
//         (element) {
//           print(element.data());
//           crewList.add(CrewModel.fromJson(element.data() as Map<String, dynamic>, element));
//         },
//       );
//       return crewList;
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   Future<List<CrewModel>> searchCrew(String value) async {
//     final List<CrewModel> crewList = [];
//     final String fieldName = value.contains('@') ? 'email' : 'phone';
//     print(fieldName);

//     try {
//       final QuerySnapshot res = await _fireStore.collection('crews').where(fieldName, isEqualTo: value).get();

//       res.docs.forEach(
//         (element) {
//           print(element.data());
//           crewList.add(CrewModel.fromJson(element.data() as Map<String, dynamic>, element));
//         },
//       );
//       return crewList;
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   Future<void> postCrewData(CrewModel data, bool waitingList) async {
//     try {
//       DocumentReference ref = _fireStore.collection(waitingList ? "waiting_list" : "applications").doc();
//       // create id for crew
//       CrewModel tempCrew = data;
//       tempCrew.id = ref.id;
//       final _data = tempCrew.toJson();
//       _data['application_sts'] = 1;
//       _data['created_on'] = FieldValue.serverTimestamp();

//       ref.set(_data);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   cousumeToken(List<dynamic> data) {
//     try {
//       _fireStore.collection('users').doc(UserData().userId).update({'plans': data});
//     } catch (e) {
//       throw e.toString();
//     }
//   }

//   // purchase a plan
//   Future<bool> purchasePlan({required String paymentId, required Plan plan}) async {
//     final _date = DateTime.now().toString();

//     try {
//       // Get document id
//       final _docId = _fireStore.collection("purchase_history").doc().id;

//       final _data = {
//         'id': _docId,
//         'user_id': UserData().userId,
//         'plan_type': plan.planType,
//         'payment_id': paymentId,
//         'purchased_on': _date,
//         'price': plan.price,
//         if (plan.planType == PlanType.nonRenewingSubscriptions) 'duration': plan.duration,
//       };
//       await _fireStore.collection('purchase_history').doc(_docId).set(_data);

//       if (plan.planType == PlanType.nonRenewingSubscriptions) {
//         final _proPlan = {
//           AppConfig.currentPlan: {
//             'id': _docId,
//             'duration': plan.duration,
//             'purchased_on': _date,
//           },
//           'plans': FieldValue.arrayUnion([
//             {
//               'id': _docId,
//               'used': false,
//             }
//           ])
//         };
//         await _fireStore.collection('users').doc(UserData().userId).update(_proPlan);
//       } else {
//         final _singlePlan = {
//           'plans': FieldValue.arrayUnion([
//             {
//               'id': _docId,
//               'used': false,
//             }
//           ])
//         };
//         await _fireStore.collection('users').doc(UserData().userId).update(_singlePlan);
//       }
//       return true;
//     } catch (e) {
//       throw (e.toString());
//     }
//   }

//   Future<Map<String, dynamic>?> getUserData() async {
//     try {
//       DocumentSnapshot ref = await _fireStore.collection("users").doc(UserData().userId).get();

//       final _data = ref.data() as Map<String, dynamic>;

//       return _data;
//     } catch (e) {
//       print(e.toString());
//       throw Exception(e.toString());
//     }
//   }
}
