import 'package:aialuno/models/exame_model.dart';
import 'package:aialuno/models/question_model.dart';
import 'package:aialuno/models/simulation_model.dart';
import 'package:aialuno/models/situation_model.dart';
import 'package:aialuno/uis/components/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskEditDS extends StatefulWidget {
  final bool isDataValid;
  final String id;
  //dados da tarefa
  final dynamic tempoPResponder;
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
  final Function(String) onCloseTaskId;

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
    this.isDataValid,
    this.tempoPResponder,
    this.onCloseTaskId,
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
        title: Text('Resolvendo ${widget.id.substring(0, 4)}'),
        actions: [
          // IconButton(
          //   tooltip: 'Link para a proposta da tarefa',
          //   icon: Text(
          //     '${widget.attempted}-${widget.attempt}',
          //     style: TextStyle(
          //       color: Colors.red,
          //       fontSize: 16.0,
          //       // height: 2,
          //     ),
          //   ),
          //   onPressed: null,
          // ),
          Container(
            width: 70.0,
            padding: EdgeInsets.only(top: 3.0, right: 4.0),
            child: CountDownTimer(
              secondsRemaining: widget?.tempoPResponder?.inSeconds ?? 0,
              whenTimeExpires: () {
                Navigator.pop(context);
                print('terminou clock edit 1');
              },
              countDownTimerStyle: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                // height: 2,
              ),
            ),
          ),
          // IconButton(
          //   tooltip: 'Link para a proposta da tarefa',
          //   icon: Icon(Icons.link),
          //   onPressed: () async {
          //     if (widget.situationRef.url != null) {
          //       if (await canLaunch(widget.situationRef.url)) {
          //         await launch(widget.situationRef.url);
          //       }
          //     }
          //   },
          // )
        ],
      ),
      body: Center(
        child: Container(
          width: 600,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: widget.isDataValid ? form() : taskClosed(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: widget.isDataValid
            ? () {
                validateData();
              }
            : null,
      ),
    );
  }

  Widget taskClosed() {
    widget.onCloseTaskId(widget.id);
    return Center(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Tarefa fechou por limite de tentativas ou tempo.',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 22.0,
            // height: 2,
          ),
          textAlign: TextAlign.center,
        ),
      )),
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Card(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Proposta:'),
              IconButton(
                color: Colors.red,
                tooltip: 'Link para a proposta da tarefa',
                icon: Icon(Icons.link),
                onPressed: () async {
                  if (widget.situationRef.url != null) {
                    if (await canLaunch(widget.situationRef.url)) {
                      await launch(widget.situationRef.url);
                    }
                  }
                },
              ),
              Text('Tentativas:'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.attempted} de ${widget.attempt}',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    // height: 2,
                  ),
                ),
              ),
              Text('Tempo: '),
              CountDownTimer(
                secondsRemaining: widget.tempoPResponder.inSeconds,
                whenTimeExpires: () async {
                  // await Future.delayed(Duration(seconds: 10));
                  // widget.onCloseTaskId(widget.id);
                  print('terminou clock edit 2');
                },
                countDownTimerStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  // height: 2,
                ),
              ),
            ],
          )),
          Text(
              'Situação: ${widget.situationRef.name} (${widget.situationRef.id.substring(0, 4)})'),
          Text(
              'Questão: ${widget.questionRef.name} (${widget.questionRef.id.substring(0, 4)})'),
          Text(
              'Exame: ${widget.exameRef.name} (${widget.exameRef.id.substring(0, 4)})'),
          Text(
              'Inicio: ${widget.start != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(widget.start) : ""}'),
          Text(
              'Iniciada em: ${widget.started != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(widget.started) : ""}'),
          Text(
              'Último envio: ${widget.lastSendAnswer != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(widget.lastSendAnswer) : ""}'),
          Text(
              'Finaliza em: ${widget.end != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(widget.end) : ""}'),
          // Text('Tempo ao iniciar: ${widget.time}h'),
          Text(
              'Peso do exame: ${widget.scoreExame}. Peso da questão: ${widget.scoreQuestion}. '),
          Row(children: [
            Text('Meus ${widget.simulationInput.length} valores individuais:'),
          ]),
          ...simulationInputBuilder(context, widget.simulationInput),
          Row(children: [
            Text('Minhas ${widget.simulationOutput.length} respostas:'),
          ]),
          ...simulationOutputBuilder(context, widget.simulationOutput),
          Container(
            height: 80,
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
        icone = IconButton(icon: Icon(Icons.looks_one), onPressed: null);
      } else if (input.type == 'palavra') {
        icone = IconButton(icon: Icon(Icons.text_format), onPressed: null);
      } else if (input.type == 'texto') {
        icone = IconButton(icon: Icon(Icons.text_fields), onPressed: null);
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
        icone = IconButton(
          icon: Icon(Icons.looks_one),
          onPressed: null,
        );
      } else if (output.type == 'palavra') {
        icone = IconButton(
          icon: Icon(Icons.text_format),
          onPressed: null,
        );
      } else if (output.type == 'texto') {
        icone = IconButton(
          icon: Icon(Icons.text_fields),
          onPressed: null,
        );
      } else if (output.type == 'url') {
        // icone = Icon(Icons.link);
        icone = IconButton(
          tooltip: 'Um link ao um site ou arquivo',
          icon: Icon(Icons.link),
          onPressed: () async {
            if (output != null) {
              if (await canLaunch(output.answer)) {
                await launch(output.answer);
              }
            }
          },
        );
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
                  initialValue: output.answer == null ? '' : output.answer,
                  // inputFormatters: [
                  //   //
                  //   FilteringTextInputFormatter.allow(
                  //       // RegExp(r'^[\\-|\\ ]'),
                  //       // RegExp(r'^([+-]?\d\.?\d*)?([eE][+-]?\d+)?'),
                  //       RegExp(r'^[+-]?\d+\.?\d*'))
                  // ],
                  // keyboardType: TextInputType.number,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText:
                        '${output.name}:  ${_simulationOutput[output.id].answer} [${output.type}]',
                  ),
                  onChanged: (newValue) {
                    try {
                      double respostaNumerica = double.parse(newValue);
                      _simulationOutput[output.id].answer = newValue;
                    } catch (error) {
                      _simulationOutput[output.id].answer = null;
                    }
                    setState(() {});
                  },
                  onSaved: (newValue) => _simulationOutput[output.id].answer =
                      newValue.isEmpty ? null : newValue,
                  validator: (value) {
                    try {
                      if (value != null && value.isNotEmpty) {
                        double.parse(_simulationOutput[output.id].answer);
                      }
                      return null;
                    } catch (error) {
                      _simulationOutput[output.id].answer = null;
                      return 'Valor NÃO foi entendido como sendo um número.';
                    }
                  },
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
                  initialValue: output.answer == null ? '' : output.answer,
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
