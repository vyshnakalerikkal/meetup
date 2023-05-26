// import 'package:beacon_app/model/crew_category.dart';
// import 'package:beacon_app/model/crew_model.dart';
// import 'package:beacon_app/services/firebase_api.dart';
// import 'package:flutter/material.dart';

// class CrewListProvider extends ChangeNotifier {
//   List<CrewModel> crews = [];
//   FilterParam? _filter;
  // Status status = Status.initilize;
  // String message = '';

  // Future<void> getCrews(FilterParam filter) async {
  //   if (filter == _filter || status == Status.busy) return;

  //   try {
  //     changeStatus(Status.busy);
  //     crews = await FirbaseApi().getCrewList(filter);
  //     _filter = filter;
  //     changeStatus(Status.success);
  //   } catch (e) {
  //     message = e.toString();
  //     changeStatus(Status.failed);
  //   }
  // }

//   Future<void> getMore() async {
//     if (status == Status.busy) return;
//     try {
//       final _docSnap = crews.last.documentSnapshot;
//       changeStatus(Status.busy);
//       final _data = await FirbaseApi().getNextcrew(_filter!, _docSnap!);
//       crews = [...crews, ..._data];
//       changeStatus(Status.success);
//     } catch (e) {
//       message = e.toString();
//       changeStatus(Status.failed);
//     }
//   }

//   void changeStatus(Status sts) {
//     status = sts;
//     notifyListeners();
//   }
// }

// enum Status { busy, success, failed, initilize }
