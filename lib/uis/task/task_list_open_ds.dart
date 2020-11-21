import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/uis/components/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListOpenDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;
  final Function(String) onCloseTaskId;
  final Function() onExameList;

  const TaskListOpenDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
    this.onCloseTaskId,
    this.onExameList,
  }) : super(key: key);

  @override
  _TaskListOpenDSState createState() => _TaskListOpenDSState();
}

class _TaskListOpenDSState extends State<TaskListOpenDS> {
  String quantidadeSingularPlural(
      dynamic quantidade, String singular, String plural) {
    if (quantidade == null) {
      return '0 $plural';
    } else if (quantidade == 1) {
      return '1 $singular';
    } else {
      return '$quantidade $plural';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Vc tem ${quantidadeSingularPlural(widget.taskList.length, "tarefa", "tarefas")}.'),
        actions: [
          // IconButton(
          //   tooltip: 'Acessar minhas turmas e tarefas antigas',
          //   icon: Icon(Icons.fact_check_outlined),
          //   onPressed: () =>
          //       Navigator.pushReplacementNamed(context, Routes.classroomList),
          // ),
          // LogoutButton(),
        ],
        leading: IconButton(
          tooltip: 'Exames',
          icon: Icon(Icons.home),
          onPressed: () {
            widget.onExameList();
          },
        ),
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: widget.taskList.length,
            itemBuilder: (context, index) {
              final task = widget.taskList[index];
              return Card(
                child: Column(
                  // alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      selected: task.isOpen,
                      title: task.tempoPResponder == null
                          ? Text('Tarefa: ${task.id.substring(0, 4)}')
                          : Text('Tarefa: ${task.id.substring(0, 4)}'),
                      subtitle: Text('${task.toString()}'),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        task.isOpen
                            ? IconButton(
                                tooltip: 'Editar esta tarefa',
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  widget.onEditTaskCurrent(task.id);
                                },
                              )
                            : Container(),
                        task.isOpen && task.tempoPResponder == null
                            ? Text(
                                'vc tem ${task.time}h pra resolver até ${task.end != null ? DateFormat('dd-MM kk:mm').format(task.end) : ""}')
                            : Container(),
                        task.isOpen && task.tempoPResponder != null
                            ? CountDownTimer(
                                secondsRemaining:
                                    task?.tempoPResponder?.inSeconds ?? 0,
                                whenTimeExpires: () async {
                                  await Future.delayed(Duration(seconds: 10));
                                  widget.onCloseTaskId(task.id);
                                  print(
                                      'terminou time em list open da task: ${task.id}');
                                },
                                countDownTimerStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  // height: 2,
                                ),
                              )
                            : Container(),
                        !task.isOpen
                            ? IconButton(
                                tooltip: 'Proposta da tarefa',
                                icon: Icon(Icons.link),
                                onPressed: () async {
                                  if (task.situationRef.url != null) {
                                    if (await canLaunch(
                                        task.situationRef.url)) {
                                      await launch(task.situationRef.url);
                                    }
                                  }
                                },
                              )
                            : Container(),
                      ],
                    )
                    // ListTile(
                    //   trailing: Column(
                    //     children: [
                    //       task?.isOpen != null && task.isOpen
                    //           ? Expanded(
                    //               flex: 1,
                    //               child: task.tempoPResponder == null
                    //                   ? Text('${task.time}h')
                    //                   : Container(
                    //                       width: 70.0,
                    //                       padding: EdgeInsets.only(
                    //                           top: 3.0, right: 4.0),
                    //                       child: CountDownTimer(
                    //                         secondsRemaining: task
                    //                                 ?.tempoPResponder
                    //                                 ?.inSeconds ??
                    //                             0,
                    //                         whenTimeExpires: () async {
                    //                           await Future.delayed(
                    //                               Duration(seconds: 10));
                    //                           widget.onCloseTaskId(task.id);
                    //                           print(
                    //                               'terminou time em list open da task: ${task.id}');
                    //                         },
                    //                         countDownTimerStyle: TextStyle(
                    //                           color: Colors.red,
                    //                           fontSize: 16.0,
                    //                           // height: 2,
                    //                         ),
                    //                       ),
                    //                     ),
                    //             )
                    //           : Container(),
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           width: 50.0,
                    //           child: task?.isOpen != null
                    //               ? IconButton(
                    //                   tooltip: 'Editar esta tarefa',
                    //                   icon: Icon(Icons.edit),
                    //                   onPressed: () async {
                    //                     widget.onEditTaskCurrent(task.id);
                    //                   },
                    //                 )
                    //               : IconButton(
                    //                   tooltip: 'Proposta da tarefa',
                    //                   icon: Icon(Icons.link),
                    //                   onPressed: () async {
                    //                     if (task.situationRef.url != null) {
                    //                       if (await canLaunch(
                    //                           task.situationRef.url)) {
                    //                         await launch(task.situationRef.url);
                    //                       }
                    //                     }
                    //                   },
                    //                 ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
