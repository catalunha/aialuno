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

class ViewModel extends BaseModel<AppState> {
  ClassroomModel classroomRef;
  List<ExameModel> exameList;
  List<TaskModel> taskList;
  Function(String) onTaskList;
  Function(String) onTaskListOpen;
  ViewModel();
  ViewModel.build({
    @required this.classroomRef,
    @required this.exameList,
    @required this.taskList,
    @required this.onTaskList,
    @required this.onTaskListOpen,
  }) : super(equals: [
          exameList,
        ]);
  @override
  ViewModel fromStore() => ViewModel.build(
        classroomRef: state.classroomState.classroomCurrent,
        exameList: state.exameState.exameList,
        taskList: state.taskState.taskList,
        onTaskList: (String exameId) {
          dispatch(SetExameCurrentSyncExameAction(exameId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forView));
          dispatch(NavigateAction.pushNamed(Routes.taskList));
        },
        onTaskListOpen: (String exameId) {
          dispatch(SetExameCurrentSyncExameAction(exameId));
          dispatch(SetTaskFilterSyncTaskAction(TaskFilter.forSolve));
          dispatch(NavigateAction.pushNamed(Routes.taskListOpen));
        },
      );
}

class ExameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      onInit: (store) {
        store.dispatch(StreamColTaskAsyncTaskAction());
        store.dispatch(StreamColExameAsyncExameAction());
      },
      builder: (context, viewModel) => ExameListDS(
        classroomRef: viewModel.classroomRef,
        exameList: viewModel.exameList,
        taskList: viewModel.taskList,
        onTaskList: viewModel.onTaskList,
        onTaskListOpen: viewModel.onTaskListOpen,
      ),
    );
  }
}
