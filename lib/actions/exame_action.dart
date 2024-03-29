import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';

// +++ Actions Sync
class SetExameCurrentSyncExameAction extends ReduxAction<AppState> {
  final String id;

  SetExameCurrentSyncExameAction(this.id);

  @override
  AppState reduce() {
    ExameModel exameModel;
    if (id == null) {
      exameModel = ExameModel(null);
    } else {
      ExameModel exameModelTemp =
          state.exameState.exameList.firstWhere((element) => element.id == id);
      exameModel =
          ExameModel(exameModelTemp.id).fromMap(exameModelTemp.toMap());
    }
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }
}

class SetExameFilterSyncExameAction extends ReduxAction<AppState> {
  final ExameFilter exameFilter;

  SetExameFilterSyncExameAction(this.exameFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameFilter: exameFilter,
      ),
    );
  }

  // void after() => dispatch(StreamColExameAsyncExameAction());
}

class SetQuestionSelectedSyncExameAction extends ReduxAction<AppState> {
  final String questionIdSelected;

  SetQuestionSelectedSyncExameAction(this.questionIdSelected);

  @override
  AppState reduce() {
    return state.copyWith(
      exameState: state.exameState.copyWith(
        questionIdSelected: questionIdSelected,
      ),
    );
  }
}

// class SetStudentSelectedSyncExameAction extends ReduxAction<AppState> {
//   final String studentIdSelected;

//   SetStudentSelectedSyncExameAction(this.studentIdSelected);

//   @override
//   AppState reduce() {
//     return state.copyWith(
//       exameState: state.exameState.copyWith(
//         studentIdSelected: studentIdSelected,
//       ),
//     );
//   }
// }

// +++ Actions Async
class StreamColExameAsyncExameAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColExameAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    Query collRef;
    collRef = firestore
        .collection(ExameModel.collection)
        // .where('userRef.id', isEqualTo: state.loggedState.userModelLogged.id)
        .where('classroomRef.id',
            isEqualTo: state.classroomState.classroomCurrent.id);
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<ExameModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) =>
                ExameModel(docSnapshot.documentID).fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<ExameModel> exameList) {
      dispatch(GetDocsExameListAsyncExameAction(exameList));
    });

    return null;
  }
}

class GetDocsExameListAsyncExameAction extends ReduxAction<AppState> {
  final List<ExameModel> exameList;

  GetDocsExameListAsyncExameAction(this.exameList);
  @override
  AppState reduce() {
    final Map<String, ExameModel> mapping = {
      for (int i = 0; i < exameList.length; i++) exameList[i].id: exameList[i]
    };

    List<ExameModel> exameListOrdered = [];
    if (state.classroomState.classroomCurrent?.exameId != null) {
      for (String id in state.classroomState.classroomCurrent.exameId)
        exameListOrdered.add(mapping[id]);
    }

    ExameModel exameModel;
    if (state.exameState.exameCurrent != null) {
      int index = exameListOrdered.indexWhere(
          (element) => element.id == state.exameState.exameCurrent.id);
      // print(index);
      if (index >= 0) {
        ExameModel exameModelTemp = exameListOrdered.firstWhere(
            (element) => element.id == state.exameState.exameCurrent.id);
        exameModel =
            ExameModel(exameModelTemp.id).fromMap(exameModelTemp.toMap());
      }
    }
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameList: exameListOrdered,
        exameCurrent: exameModel,
      ),
    );
  }
}

class AddDocExameCurrentAsyncExameAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  AddDocExameCurrentAsyncExameAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
  });
  @override
  Future<AppState> reduce() async {
    print('AddDocExameCurrentAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());
    exameModel.userRef = UserModel(state.loggedState.userModelLogged.id)
        .fromMap(state.loggedState.userModelLogged.toMapRef());
    exameModel.classroomRef =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMapRef());
    exameModel.name = name;
    exameModel.description = description;
    exameModel.start = start;
    exameModel.end = end;
    exameModel.scoreExame = scoreExame;
    exameModel.attempt = attempt;
    exameModel.time = time;
    exameModel.error = error;
    exameModel.scoreQuestion = scoreQuestion;
    var docRefExame = firestore.collection(ExameModel.collection).document();
    print('Novo Exame: ${docRefExame.documentID}');
    await firestore
        .collection(ClassroomModel.collection)
        .document(state.classroomState.classroomCurrent.id)
        .updateData({
      'exameId': FieldValue.arrayUnion([docRefExame.documentID])
    }).then((value) async {
      await firestore
          .collection(ExameModel.collection)
          .document(docRefExame.documentID)
          .setData(exameModel.toMap());
    });

    // await firestore
    //     .collection(ExameModel.collection)
    //     .add(exameModel.toMap())
    //     .then((exame) {
    //   firestore
    //       .collection(ClassroomModel.collection)
    //       .document(state.classroomState.classroomCurrent.id)
    //       .updateData({
    //     'exameId': FieldValue.arrayUnion([exame.documentID])
    //   });
    // });

    return null;
  }

  // @override
  // void after() => dispatch(StreamColExameAsyncExameAction());
}

class UpdateDocExameCurrentAsyncExameAction extends ReduxAction<AppState> {
  final String name;
  final String description;
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  final bool isDelivered;
  final bool isDelete;
  UpdateDocExameCurrentAsyncExameAction({
    this.name,
    this.description,
    this.start,
    this.end,
    this.scoreExame,
    this.attempt,
    this.time,
    this.error,
    this.scoreQuestion,
    this.isDelivered,
    this.isDelete,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateDocExameCurrentAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());

    if (isDelete) {
      await firestore
          .collection(ClassroomModel.collection)
          .document(state.classroomState.classroomCurrent.id)
          .updateData({
        'exameId': FieldValue.arrayRemove([exameModel.id])
      }).then((value) {
        firestore
            .collection(ExameModel.collection)
            .document(exameModel.id)
            .delete();
        return state.copyWith(
          exameState: state.exameState.copyWith(
            exameCurrent: null,
          ),
        );
      });
    } else {
      exameModel.name = name;
      exameModel.description = description;
      exameModel.start = start;
      exameModel.end = end;
      exameModel.scoreExame = scoreExame;
      exameModel.attempt = attempt;
      exameModel.time = time;
      exameModel.error = error;
      exameModel.scoreQuestion = scoreQuestion;

      await firestore
          .collection(ExameModel.collection)
          .document(exameModel.id)
          .updateData(exameModel.toMap());
    }
    return null;
  }

  // @override
  // void after() => dispatch(StreamColExameAsyncExameAction());
}

class UpdateDocSetQuestionInExameCurrentAsyncExameAction
    extends ReduxAction<AppState> {
  final String questionId;
  final bool isAddOrRemove;
  UpdateDocSetQuestionInExameCurrentAsyncExameAction({
    this.questionId,
    this.isAddOrRemove,
  });
  @override
  Future<AppState> reduce() async {
    print(
        'UpdateDocSetQuestionInExameCurrentAsyncExameAction: $questionId $isAddOrRemove');
    Firestore firestore = Firestore.instance;

    ExameModel exameModel = ExameModel(state.exameState.exameCurrent.id)
        .fromMap(state.exameState.exameCurrent.toMap());

    if (exameModel.questionMap == null)
      exameModel.questionMap = Map<String, bool>();
    if (isAddOrRemove) {
      if (!exameModel.questionMap.containsKey(questionId)) {
        exameModel.questionMap.addAll({questionId: false});
      }
    } else {
      exameModel.questionMap.remove(questionId);
    }
    await firestore
        .collection(ExameModel.collection)
        .document(exameModel.id)
        .updateData(exameModel.toMap());
    return state.copyWith(
      exameState: state.exameState.copyWith(
        exameCurrent: exameModel,
      ),
    );
  }

  @override
  void before() => dispatch(WaitAction.add(this));
  @override
  void after() {
    // dispatch(StreamColExameAsyncExameAction());
    dispatch(WaitAction.remove(this));
  }
}

class UpdateOrderExameListAsyncExameAction extends ReduxAction<AppState> {
  final int oldIndex;
  final int newIndex;

  UpdateOrderExameListAsyncExameAction({
    this.oldIndex,
    this.newIndex,
  });
  @override
  Future<AppState> reduce() async {
    print('UpdateOrderExameListInDocClassroomAsyncExameAction...');
    Firestore firestore = Firestore.instance;
    ClassroomModel classroomModel =
        ClassroomModel(state.classroomState.classroomCurrent.id)
            .fromMap(state.classroomState.classroomCurrent.toMap());
    int _newIndex = newIndex;
    if (newIndex > oldIndex) {
      _newIndex -= 1;
    }
    dynamic exameOld = classroomModel.exameId[oldIndex];
    classroomModel.exameId.removeAt(oldIndex);
    classroomModel.exameId.insert(_newIndex, exameOld);

    await firestore
        .collection(ClassroomModel.collection)
        .document(state.classroomState.classroomCurrent.id)
        .updateData({'exameId': classroomModel.exameId});

    return null;
  }

  // @override
  // void after() {
  //   // dispatch(StreamColClassroomAsyncClassroomAction());
  //   dispatch(GetDocsUserModelAsyncLoggedAction(
  //       id: state.loggedState.userModelLogged.id));
  // }
}
