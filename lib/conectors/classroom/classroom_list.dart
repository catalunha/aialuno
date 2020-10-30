import 'package:aialuno/actions/classroom_action.dart';
import 'package:aialuno/actions/task_action.dart';
import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:aialuno/uis/classroom/classroom_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  UserModel userLogged;
  List<ClassroomModel> classroomList;
  // Function(String) onEditClassroomCurrent;
  Function(String) onStudentList;
  // Function(String) onExameList;
  // Function() onSituationList;
  Function(String) onTaskList;
  // Function(int, int) onChangeClassroomListOrder;
  ViewModel();
  ViewModel.build({
    @required this.userLogged,
    @required this.classroomList,
    // @required this.onEditClassroomCurrent,
    @required this.onStudentList,
    // @required this.onExameList,
    // @required this.onSituationList,
    @required this.onTaskList,
    // @required this.onChangeClassroomListOrder,
  }) : super(equals: [
          userLogged,
          classroomList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        userLogged: state.loggedState.userModelLogged,
        classroomList: state.classroomState.classroomList,
        // onEditClassroomCurrent: (String id) {
        //   dispatch(SetClassroomCurrentSyncClassroomAction(id));
        //   dispatch(NavigateAction.pushNamed(Routes.classroomEdit));
        // },
        onStudentList: (String classroomId) {
          dispatch(SetClassroomCurrentSyncClassroomAction(classroomId));
          dispatch(NavigateAction.pushNamed(Routes.studentList));
        },
        onTaskList: (String classroomId) {
          dispatch(SetClassroomCurrentSyncClassroomAction(classroomId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forView));

          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
        // onExameList: (String id) {
        //   dispatch(SetClassroomCurrentSyncClassroomAction(id));
        //   dispatch(NavigateAction.pushNamed(Routes.exameList));
        // },
        // onSituationList: () {
        //   dispatch(NavigateAction.pushNamed(Routes.situationList));
        // },
        // onKnowList: () {
        //   dispatch(NavigateAction.pushNamed(Routes.knowList));
        // },
        // onChangeClassroomListOrder: (int oldIndex, int newIndex) {
        //   dispatch(UpdateDocclassroomIdInUserAsyncClassroomAction(
        //     oldIndex: oldIndex,
        //     newIndex: newIndex,
        //   ));
        // },
      );
}

class ClassroomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) =>
          store.dispatch(StreamColClassroomAsyncClassroomAction()),
      builder: (context, viewModel) => ClassroomListDS(
        userLogged: viewModel.userLogged,
        classroomList: viewModel.classroomList,
        // onEditClassroomCurrent: viewModel.onEditClassroomCurrent,
        onStudentList: viewModel.onStudentList,
        // onExameList: viewModel.onExameList,
        onTaskList: viewModel.onTaskList,
        // onSituationList: viewModel.onSituationList,
        // onChangeClassroomListOrder: viewModel.onChangeClassroomListOrder,
      ),
    );
  }
}
