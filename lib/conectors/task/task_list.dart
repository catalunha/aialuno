import 'package:aialuno/actions/exame_action.dart';
import 'package:aialuno/actions/task_action.dart';
import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:aialuno/uis/task/task_list_ds.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

class ViewModel extends Vm {
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;
  final Function(String) onCloseTaskId;
  final Function() onExameList;

  ViewModel({
    @required this.taskList,
    @required this.onExameList,
    @required this.onEditTaskCurrent,
    @required this.onCloseTaskId,
  }) : super(equals: [
          taskList,
        ]);
}

class Factory extends VmFactory<AppState, TaskList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        taskList: _taskListFilter(state.taskState.taskList),
        onEditTaskCurrent: (String id) {
          dispatch(SetTaskCurrentSyncTaskAction(id));
          // dispatch(NavigateAction.pushNamed(Routes.taskEdit));
        },
        onCloseTaskId: (String closeTaskId) {
          dispatch(CloseTaskAsyncTaskAction(closeTaskId));
        },
        onExameList: () {
          dispatchFuture(SetExameCurrentSyncExameAction(null)).then((value) {
            dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forSolve));
            dispatch(StreamColTaskAsyncTaskAction());
            dispatch(NavigateAction.pop());
          });

          // dispatch(NavigateAction.popUntil(Routes.welcome));
        },
      );
  List<TaskModel> _taskListFilter(List<TaskModel> _taskList) {
    List<TaskModel> _return = _taskList
        .where((element) =>
            element.exameRef.id == state.exameState.exameCurrent.id)
        .toList();
    return _return;
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) {
        store.dispatch(StreamColTaskAsyncTaskAction());
      },
      builder: (context, viewModel) => TaskListDS(
        taskList: viewModel.taskList,
        onExameList: viewModel.onExameList,
        onEditTaskCurrent: viewModel.onEditTaskCurrent,
        onCloseTaskId: viewModel.onCloseTaskId,
      ),
    );
  }
}
