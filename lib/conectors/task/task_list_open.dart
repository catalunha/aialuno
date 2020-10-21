import 'package:aialuno/actions/task_action.dart';
import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:aialuno/uis/task/task_list_open_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends BaseModel<AppState> {
  UserModel userModel;
  List<TaskModel> taskList;
  Function(String) onEditTaskCurrent;
  Function(String) onCloseTaskId;

  ViewModel();
  ViewModel.build({
    @required this.userModel,
    @required this.taskList,
    @required this.onEditTaskCurrent,
    @required this.onCloseTaskId,
  }) : super(equals: [
          userModel,
          taskList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        userModel: state.loggedState.userModelLogged,
        taskList: state.taskState.taskList,
        onEditTaskCurrent: (String id) {
          dispatch(SetTaskCurrentSyncTaskAction(id));
          // dispatch(NavigateAction.pushNamed(Routes.taskEdit));
        },
        onCloseTaskId: (String closeTaskId) {
          dispatch(CloseTaskAsyncTaskAction(closeTaskId));
        },
      );
}

class TaskListOpen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) {
        store.dispatch(SetTaskFilterSyncTaskAction(TaskFilter.isActive));
        store.dispatch(StreamColTaskAsyncTaskAction());
      },
      builder: (context, viewModel) => TaskListOpenDS(
        userModel: viewModel.userModel,
        taskList: viewModel.taskList,
        onEditTaskCurrent: viewModel.onEditTaskCurrent,
        onCloseTaskId: viewModel.onCloseTaskId,
      ),
    );
  }
}
