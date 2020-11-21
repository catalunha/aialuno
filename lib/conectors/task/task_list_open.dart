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
  List<TaskModel> taskList;
  Function(String) onEditTaskCurrent;
  Function(String) onCloseTaskId;
  Function() onExameList;

  ViewModel();
  ViewModel.build({
    @required this.taskList,
    @required this.onExameList,
    @required this.onEditTaskCurrent,
    @required this.onCloseTaskId,
  }) : super(equals: [
          taskList,
        ]);
  List<TaskModel> taskListFilter(List<TaskModel> _taskList) {
    List<TaskModel> _return = _taskList
        .where((element) =>
            element.exameRef.id == state.exameState.exameCurrent.id)
        .toList();
    return _return;
  }

  @override
  ViewModel fromStore() => ViewModel.build(
        taskList: taskListFilter(state.taskState.taskList),
        onEditTaskCurrent: (String id) {
          dispatch(SetTaskCurrentSyncTaskAction(id));
          // dispatch(NavigateAction.pushNamed(Routes.taskEdit));
        },
        onCloseTaskId: (String closeTaskId) {
          dispatch(CloseTaskAsyncTaskAction(closeTaskId));
        },
        onExameList: () {
          dispatch(NavigateAction.popUntil(Routes.welcome));
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
        store.dispatch(StreamColTaskAsyncTaskAction());
      },
      builder: (context, viewModel) => TaskListOpenDS(
        taskList: viewModel.taskList,
        onExameList: viewModel.onExameList,
        onEditTaskCurrent: viewModel.onEditTaskCurrent,
        onCloseTaskId: viewModel.onCloseTaskId,
      ),
    );
  }
}
