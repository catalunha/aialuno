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
  Function(String) onStudentList;
  Function(String) onTaskList;
  Function(String) onTaskListOpen;
  Function(int, int) onChangeClassroomListOrder;
  ViewModel();
  ViewModel.build({
    @required this.userLogged,
    @required this.classroomList,
    @required this.onStudentList,
    @required this.onTaskList,
    @required this.onTaskListOpen,
    @required this.onChangeClassroomListOrder,
  }) : super(equals: [
          userLogged,
          classroomList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        userLogged: state.loggedState.userModelLogged,
        classroomList: state.classroomState.classroomList,
        onStudentList: (String classroomId) {
          dispatch(SetClassroomCurrentSyncClassroomAction(classroomId));
          dispatch(NavigateAction.pushNamed(Routes.studentList));
        },
        onTaskList: (String classroomId) {
          dispatch(SetClassroomCurrentSyncClassroomAction(classroomId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forView));

          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
        onTaskListOpen: (String classroomId) {
          dispatch(SetClassroomCurrentSyncClassroomAction(classroomId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forSolve));
          dispatch(NavigateAction.pushNamed(Routes.taskListOpen));
        },
        onChangeClassroomListOrder: (int oldIndex, int newIndex) {
          dispatch(UpdateDocclassroomIdInUserAsyncClassroomAction(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ));
        },
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
        onStudentList: viewModel.onStudentList,
        onTaskList: viewModel.onTaskList,
        onTaskListOpen: viewModel.onTaskListOpen,
      ),
    );
  }
}
