import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/models/question_model.dart';
import 'package:aialuno/models/simulation_model.dart';
import 'package:aialuno/models/situation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskEditDS extends StatefulWidget {
  final String id;
  //dados do exame
  final dynamic start;
  final dynamic end;
  final int scoreExame;
  //dados da questao
  final int attempt;
  final int time;
  final int error;
  final int scoreQuestion;
  // dados para atualização
  final dynamic started;
  final dynamic lastSendAnswer;
  final dynamic attempted;
  //Referencias
  final ExameModel exameRef;
  final QuestionModel questionRef;
  final SituationModel situationRef;
  //input e output
  final Map<String, Input> simulationInput;
  final Map<String, Output> simulationOutput;

  //
  final Function(Map<String, Output>) onUpdateSimulationOutput;

  const TaskEditDS({
    Key key,
    this.end,
    this.attempt,
    this.time,
    this.error,
    this.id,
    this.exameRef,
    this.questionRef,
    this.situationRef,
    this.started,
    this.lastSendAnswer,
    this.attempted,
    this.simulationInput,
    this.simulationOutput,
    this.onUpdateSimulationOutput,
    this.start,
    this.scoreExame,
    this.scoreQuestion,
  }) : super(key: key);
  @override
  _TaskEditDSState createState() => _TaskEditDSState();
}

class _TaskEditDSState extends State<TaskEditDS> {
  final formKey = GlobalKey<FormState>();

  Map<String, Output> _simulationOutput = Map<String, Output>(); //

  void validateData() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      widget.onUpdateSimulationOutput(_simulationOutput);
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _simulationOutput.addAll(widget.simulationOutput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar esta tarefa ${widget.id.substring(0, 4)}'),
        actions: [
          IconButton(
            tooltip: 'Link para a proposta da tarefa',
            icon: Icon(Icons.link),
            onPressed: () async {
              if (widget.situationRef.url != null) {
                if (await canLaunch(widget.situationRef.url)) {
                  await launch(widget.situationRef.url);
                }
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: form(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          validateData();
        },
      ),
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Text('Inicia em: ${widget.start}'),
          Text('Iniciada em: ${widget.started}'),
          Text('Último envio: ${widget.lastSendAnswer}'),
          Text('Finaliza em: ${widget.end}'),
          Text('Tempo ao iniciar: ${widget.time}h'),
          Text('Tentativas: ${widget.attempted} de ${widget.attempt}'),
          Text(
              'Peso do exame: ${widget.scoreExame} e da questão: ${widget.scoreQuestion}. '),
          Text(
              'Exame: ${widget.exameRef.name}. Questão: ${widget.questionRef.name}. Situação: ${widget.situationRef.name}. Link na barra superior.'),
          Row(children: [
            Text('Entradas para solução: ${widget.simulationInput.length}'),
          ]),
          ...simulationInputBuilder(context, widget.simulationInput),
          Row(children: [
            Text(
                'Respostas do desenvolvimento: ${widget.simulationOutput.length}'),
          ]),
          ...simulationOutputBuilder(context, widget.simulationOutput),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }

  List<Widget> simulationInputBuilder(
      BuildContext context, Map<String, Input> simulationInputMap) {
    List<Widget> itemList = [];
    List<Input> inputList = simulationInputMap.values.toList();
    inputList.sort((a, b) => a.name.compareTo(b.name));

    for (var input in inputList) {
      Widget icone = Icon(Icons.question_answer);
      if (input.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (input.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (input.type == 'texto') {
        icone = Icon(Icons.text_fields);
      } else if (input.type == 'url') {
        icone = IconButton(
          tooltip: 'Um link ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (input != null) {
              if (await canLaunch(input.value)) {
                await launch(input.value);
              }
            }
          },
        );
      }
      itemList.add(Row(
        children: [
          icone,
          Container(
            width: 10,
          ),
          Text('${input.name}'),
          Text(' = '),
          input.type == 'url'
              ? Text('(${input.value.length}c)')
              : Text('${input.value}'),
        ],
      ));
    }
    return itemList;
  }

  List<Widget> simulationOutputBuilder(
      BuildContext context, Map<String, Output> simulationOutputMap) {
    List<Widget> itemList = [];
    List<Output> outputList = simulationOutputMap.values.toList();
    outputList.sort((a, b) => a.name.compareTo(b.name));

    for (var output in outputList) {
      Widget icone = Icon(Icons.question_answer);

      if (output.type == 'numero') {
        icone = Icon(Icons.looks_one);
      } else if (output.type == 'palavra') {
        icone = Icon(Icons.text_format);
      } else if (output.type == 'texto') {
        icone = Icon(Icons.text_fields);
      } else if (output.type == 'url') {
        icone = Icon(Icons.link);
      } else if (output.type == 'arquivo') {
        icone = Icon(Icons.description);
      }
      if (output.type == 'numero') {
        itemList.add(
          Row(
            children: [
              icone,
              Container(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: output.answer == null ? '0' : output.answer,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: '${output.name}:: [${output.type}]',
                  ),
                  onChanged: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                  onSaved: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                ),
              ),
            ],
          ),
        );
      } else if (output.type == 'palavra') {
        itemList.add(
          Row(
            children: [
              icone,
              Container(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: output.answer == null ? '...' : output.answer,
                  decoration: InputDecoration(
                    labelText: '${output.name}: [${output.type}]',
                  ),
                  onChanged: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                  onSaved: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                ),
              ),
            ],
          ),
        );
      } else if (output.type == 'texto') {
        itemList.add(
          Row(
            children: [
              icone,
              Container(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: output.answer == null ? '...' : output.answer,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: '${output.name}: [${output.type}]',
                  ),
                  onChanged: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                  onSaved: (newValue) =>
                      _simulationOutput[output.id].answer = newValue,
                ),
              ),
            ],
          ),
        );
      } else if (output.type == 'url') {
        itemList.add(
          Row(
            children: [
              icone,
              Container(
                width: 10,
              ),
              Expanded(
                  child: TextFormField(
                initialValue: output.answer == null ? '...' : output.answer,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: '${output.name}: [${output.type}]',
                ),
                onChanged: (newValue) =>
                    _simulationOutput[output.id].answer = newValue,
                onSaved: (newValue) =>
                    _simulationOutput[output.id].answer = newValue,
              )),
            ],
          ),
        );
      }
    }
    return itemList;
  }
}
