import 'package:aialuno/actions/task_action.dart';
import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/states/types_states.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:aialuno/actions/exame_action.dart';
import 'package:aialuno/models/classroom_model.dart';
import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:aialuno/uis/exame/exame_list_ds.dart';

class ViewModel extends Vm {
  final ClassroomModel classroomRef;
  final List<ExameModel> exameList;
  final List<TaskModel> taskList;
  final Function(String) onTaskList;
  ViewModel({
    @required this.classroomRef,
    @required this.exameList,
    @required this.taskList,
    @required this.onTaskList,
  }) : super(equals: [
          classroomRef,
          exameList,
          taskList,
        ]);
}

class Factory extends VmFactory<AppState, ExameList> {
  Factory(widget) : super(widget);
  @override
  ViewModel fromStore() => ViewModel(
        classroomRef: state.classroomState.classroomCurrent,
        exameList: state.exameState.exameList,
        taskList: state.taskState.taskList,
        onTaskList: (String exameId) {
          dispatch(SetExameCurrentSyncExameAction(exameId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forView));
          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
      );
}

class ExameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      vm: Factory(this),
      onInit: (store) {
        store.dispatch(StreamColExameAsyncExameAction());
      },
      builder: (BuildContext context, ViewModel viewModel) => ExameListDS(
        classroomRef: viewModel.classroomRef,
        exameList: viewModel.exameList,
        taskList: viewModel.taskList,
        onTaskList: viewModel.onTaskList,
      ),
    );
  }
}
