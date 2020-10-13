import 'package:aialuno/actions/task_action.dart';
import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/models/question_model.dart';
import 'package:aialuno/models/simulation_model.dart';
import 'package:aialuno/models/situation_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/uis/task/task_edit_ds.dart';
import 'package:flutter/material.dart';
import 'package:aialuno/states/app_state.dart';
import 'package:async_redux/async_redux.dart';

class ViewModel extends BaseModel<AppState> {
  String id;
  //dados do exame
  dynamic start;
  dynamic end;
  int scoreExame;
  //dados da questao
  int attempt;
  int time;
  int error;
  int scoreQuestion;
  // dados para atualização
  dynamic started;
  dynamic lastSendAnswer;
  dynamic attempted;
  //Referencias
  ExameModel exameRef;
  QuestionModel questionRef;
  SituationModel situationRef;
  //input e output
  Map<String, Input> simulationInput;
  Map<String, Output> simulationOutput;

  Function(Map<String, Output>) onUpdateSimulationOutput;

  ViewModel();
  ViewModel.build({
    @required this.id,
    @required this.start,
    @required this.end,
    @required this.scoreExame,
    @required this.attempt,
    @required this.time,
    @required this.error,
    @required this.scoreQuestion,
    @required this.started,
    @required this.lastSendAnswer,
    @required this.attempted,
    @required this.exameRef,
    @required this.questionRef,
    @required this.situationRef,
    @required this.simulationInput,
    @required this.simulationOutput,
    @required this.onUpdateSimulationOutput,
  }) : super(equals: [
          id,
          start,
          end,
          scoreExame,
          attempt,
          time,
          error,
          scoreQuestion,
          started,
          lastSendAnswer,
          attempted,
          exameRef,
          questionRef,
          situationRef,
          simulationInput,
          simulationOutput,
        ]);

  @override
  ViewModel fromStore() => ViewModel.build(
        id: state.taskState.taskCurrent.id,
        start: state.taskState.taskCurrent.start,
        end: state.taskState.taskCurrent.end,
        scoreExame: state.taskState.taskCurrent.scoreExame,
        attempt: state.taskState.taskCurrent.attempt,
        time: state.taskState.taskCurrent.time,
        error: state.taskState.taskCurrent.error,
        scoreQuestion: state.taskState.taskCurrent.scoreQuestion,
        started: state.taskState.taskCurrent.started,
        lastSendAnswer: state.taskState.taskCurrent.lastSendAnswer,
        attempted: state.taskState.taskCurrent.attempted,
        exameRef: state.taskState.taskCurrent.exameRef,
        questionRef: state.taskState.taskCurrent.questionRef,
        situationRef: state.taskState.taskCurrent.situationRef,
        simulationInput: state.taskState.taskCurrent.simulationInput,
        simulationOutput: state.taskState.taskCurrent.simulationOutput,
        onUpdateSimulationOutput: (Map<String, Output> _simulationOutput) {
          dispatch(
              UpdateOutputAsyncTaskAction(simulationOutput: _simulationOutput));
          dispatch(NavigateAction.pop());
        },
      );
}

class TaskEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      //debug: this,
      model: ViewModel(),
      builder: (context, viewModel) => TaskEditDS(
        id: viewModel.id,
        start: viewModel.start,
        end: viewModel.end,
        scoreExame: viewModel.scoreExame,
        attempt: viewModel.attempt,
        time: viewModel.time,
        error: viewModel.error,
        scoreQuestion: viewModel.scoreQuestion,
        started: viewModel.started,
        lastSendAnswer: viewModel.lastSendAnswer,
        attempted: viewModel.attempted,
        exameRef: viewModel.exameRef,
        questionRef: viewModel.questionRef,
        situationRef: viewModel.situationRef,
        simulationInput: viewModel.simulationInput,
        simulationOutput: viewModel.simulationOutput,
        onUpdateSimulationOutput: viewModel.onUpdateSimulationOutput,
      ),
    );
  }
}
