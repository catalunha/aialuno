import 'package:aialuno/models/simulation_model.dart';
import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// +++ Actions Sync
class SetTaskCurrentSyncTaskAction extends ReduxAction<AppState> {
  final String id;

  SetTaskCurrentSyncTaskAction(this.id);

  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;
    TaskModel taskModel;

    TaskModel taskModelTemp =
        state.taskState.taskList.firstWhere((element) => element.id == id);
    taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());

    taskModel.updateAll();
    if (taskModel.started == null) {
      taskModel.started = DateTime.now();
      // taskModel.started = FieldValue.serverTimestamp();
      final docRef =
          firestore.collection(TaskModel.collection).document(taskModel.id);
      await docRef.setData(
        taskModel.toMap(),
        merge: true,
      );
    }

    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskCurrent: taskModel,
      ),
    );
  }

  void after() => dispatch(NavigateAction.pushNamed(Routes.taskEdit));
}

class SetTaskFilterSyncTaskAction extends ReduxAction<AppState> {
  final TaskFilter taskFilter;

  SetTaskFilterSyncTaskAction(this.taskFilter);

  @override
  AppState reduce() {
    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskFilter: taskFilter,
      ),
    );
  }

  // void after() => dispatch(StreamColTaskAsyncTaskAction());
}

// +++ Actions Async
class StreamColTaskAsyncTaskAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    print('StreamColTaskAsyncTaskAction...');
    Firestore firestore = Firestore.instance;
    String studentUserId = state.userState.userCurrent.id;
    Query collRef;
    if (state.taskState.taskFilter == TaskFilter.isActive) {
      print('TaskFilter.isActive');
      collRef = firestore
          .collection(TaskModel.collection)
          .where('studentUserRef.id', isEqualTo: studentUserId)
          .where('isOpen', isEqualTo: true)
          .where('start', isLessThan: DateTime.now());
    } else if (state.taskState.taskFilter ==
        TaskFilter.isActiveByClassroomActive) {
      print('TaskFilter.isActiveByClassroomActive');
      String classroomId = state.classroomState.classroomCurrent.id;
      collRef = firestore
          .collection(TaskModel.collection)
          .where('classroomRef.id', isEqualTo: classroomId)
          .where('studentUserRef.id', isEqualTo: studentUserId)
          // .where('open', isEqualTo: true)
          .where('start', isLessThan: DateTime.now());
    }
    Stream<QuerySnapshot> streamQuerySnapshot = collRef.snapshots();

    Stream<List<TaskModel>> streamList = streamQuerySnapshot.map(
        (querySnapshot) => querySnapshot.documents
            .map((docSnapshot) =>
                TaskModel(docSnapshot.documentID).fromMap(docSnapshot.data))
            .toList());
    streamList.listen((List<TaskModel> list) {
      dispatch(GetDocsTaskListAsyncTaskAction(list));
    });
    return null;
  }
}

class GetDocsTaskListAsyncTaskAction extends ReduxAction<AppState> {
  final List<TaskModel> taskList;

  GetDocsTaskListAsyncTaskAction(this.taskList);

  @override
  Future<AppState> reduce() async {
    Firestore firestore = Firestore.instance;

    TaskModel taskModel;
    print('GetDocsTaskListAsyncTaskAction... ${taskList.length}');
    for (var task in taskList) {
      print('::>${task.isOpen}');
      bool _isOpen = task.isOpen;
      bool _updateIsOpen = task.updateIsOpen;
      print('::>${task.isOpen}');

      print(
          'task1: ${task.id}. task.isOpen:${task.isOpen}. task.updateIsOpen:${task.updateIsOpen}. (task.isOpen != task.updateIsOpen):${(task.isOpen != task.updateIsOpen)}. true != false:${true != false}. _isOpen != _updateIsOpen:${_isOpen != _updateIsOpen}');
      if ((_isOpen != _updateIsOpen)) {
        // if (!task.updateIsOpen) {
        print('task2: ${task.id} ${task.isOpen} ${task.updateIsOpen}');
        final taskDoc =
            firestore.collection(TaskModel.collection).document(task.id);
        await taskDoc.setData(
          {'isOpen': false},
          merge: true,
        );
        return null;
      }
    }

    if (state.taskState.taskCurrent != null) {
      int index = taskList.indexWhere(
          (element) => element.id == state.taskState.taskCurrent.id);
      print(index);
      if (index >= 0) {
        TaskModel taskModelTemp = taskList.firstWhere(
            (element) => element.id == state.taskState.taskCurrent.id);
        taskModel = TaskModel(taskModelTemp.id).fromMap(taskModelTemp.toMap());
      }
    }

    return state.copyWith(
      taskState: state.taskState.copyWith(
        taskList: taskList,
        taskCurrent: taskModel,
      ),
    );
  }
}

class UpdateDocTaskCurrentAsyncTaskAction extends ReduxAction<AppState> {
  //dados do exame
  final dynamic started;
  final dynamic lastSendAnswer;
  final dynamic attempted;
  UpdateDocTaskCurrentAsyncTaskAction({
    this.started,
    this.lastSendAnswer,
    this.attempted,
  });
  @override
  // Future<AppState> reduce() async {
  AppState reduce() {
    print('UpdateDocQuestionCurrentAsyncQuestionAction...');
    Firestore firestore = Firestore.instance;
    TaskModel taskModel = TaskModel(state.taskState.taskCurrent.id)
        .fromMap(state.taskState.taskCurrent.toMap());

    // final docRef = _firestore
    //     .collection(TarefaModel.collection)
    //     .document(_state.tarefaModel.id);
    // TarefaModel tarefaUpdate = TarefaModel(
    //     iniciou: _state.tarefaModel.iniciou,
    //     tentou: Bootstrap.instance.fieldValue.increment(1),
    //     enviou: Bootstrap.instance.fieldValue.serverTimestamp(),
    //     modificado: Bootstrap.instance.fieldValue.serverTimestamp(),
    //     gabarito: _state.resposta,
    //     aberta: _state.tarefaModel.isAberta);

    // await docRef.setData(
    //   tarefaUpdate.toMap(),
    //   merge: true,
    // );

    // if (isDelete) {
    //   await firestore
    //       .collection(TaskModel.collection)
    //       .document(taskModel.id)
    //       .delete();
    // } else {
    //   taskModel.start = start;
    //   taskModel.end = end;
    //   taskModel.scoreExame = scoreExame;
    //   taskModel.attempt = attempt;
    //   taskModel.time = time;
    //   taskModel.error = error;
    //   taskModel.scoreQuestion = scoreQuestion;
    //   taskModel.attempted = attempted;
    //   // taskModel.isOpen = isOpen;
    //   if (nullStarted) {
    //     taskModel.started = null;
    //   }
    //   await firestore
    //       .collection(TaskModel.collection)
    //       .document(taskModel.id)
    //       .updateData(taskModel.toMap());
    // }
    return null;
  }
}

class UpdateOutputAsyncTaskAction extends ReduxAction<AppState> {
  //dados do exame
  final Map<String, Output> simulationOutput;

  UpdateOutputAsyncTaskAction({
    this.simulationOutput,
  });
  @override
  Future<AppState> reduce() async {
    // AppState reduce() {
    print('UpdateOutputAsyncTaskAction...');
    Firestore firestore = Firestore.instance;
    TaskModel taskModel = TaskModel(state.taskState.taskCurrent.id)
        .fromMap(state.taskState.taskCurrent.toMap());
    print(simulationOutput);
    for (var item in simulationOutput.entries) {
      // print('${item.key}: ${item.value.toMap()}');
      //+++ Corrigir textos.
      if (item.value.type == 'palavra' &&
          item.value.answer != null &&
          item.value.answer.isNotEmpty) {
        if (item.value.value == item.value.answer) {
          simulationOutput[item.key].right = true;
        } else {
          simulationOutput[item.key].right = false;
        }
      }
      //+++ Corrigir numeros.
      if (item.value.type == 'numero' &&
          item.value.answer != null &&
          item.value.answer.isNotEmpty) {
        double resposta = double.parse(item.value.answer);
        double valor = double.parse(item.value.value);
        double erroRelativoCalculado =
            (resposta - valor).abs() / valor.abs() * 100;
        double erroRelativoPermitido = taskModel.error.toDouble();

        if (erroRelativoCalculado <= erroRelativoPermitido) {
          simulationOutput[item.key].right = true;
        } else {
          simulationOutput[item.key].right = false;
        }
      }
    }
    for (var item in simulationOutput.entries) {
      print('${item.key}: ${item.value.toMap()}');
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (simulationOutput != null && simulationOutput is Map) {
      data["simulationOutput"] = Map<String, dynamic>();
      for (var item in simulationOutput.entries) {
        data["simulationOutput"][item.key] = item.value.toMap();
      }
    }
    data['attempted'] = FieldValue.increment(1);
    data['lastSendAnswer'] = FieldValue.serverTimestamp();
    data['isOpen'] = taskModel.updateIsOpen;

    await firestore
        .collection(TaskModel.collection)
        .document(taskModel.id)
        .updateData(data);

    return null;
  }
}
