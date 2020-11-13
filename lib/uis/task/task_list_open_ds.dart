import 'package:aialuno/conectors/components/logout_button.dart';
import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/models/user_model.dart';
import 'package:aialuno/routes.dart';
import 'package:aialuno/uis/components/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListOpenDS extends StatefulWidget {
  final UserModel userModel;
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;
  final Function(String) onCloseTaskId;

  const TaskListOpenDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
    this.userModel,
    this.onCloseTaskId,
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
      ),
      body: Center(
        child: Container(
          width: 600,
          child: ListView.builder(
            itemCount: widget.taskList.length,
            itemBuilder: (context, index) {
              final task = widget.taskList[index];
              return Card(
                child: Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      trailing: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: task.tempoPResponder == null
                                ? Text('${task.time}h')
                                : Container(
                                    width: 70.0,
                                    padding:
                                        EdgeInsets.only(top: 3.0, right: 4.0),
                                    child: CountDownTimer(
                                      secondsRemaining:
                                          task?.tempoPResponder?.inSeconds ?? 0,
                                      whenTimeExpires: () async {
                                        await Future.delayed(
                                            Duration(seconds: 10));
                                        widget.onCloseTaskId(task.id);
                                        print(
                                            'terminou time em list open da task: ${task.id}');
                                      },
                                      countDownTimerStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0,
                                        // height: 2,
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 50.0,
                              child: IconButton(
                                tooltip: 'Editar esta tarefa',
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  widget.onEditTaskCurrent(task.id);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      selected: task?.started != null ? true : false,
                      title: task.tempoPResponder == null
                          ? Text(
                              'Tarefa: ${task.id.substring(0, 4)}\nFim: ${task.end != null ? DateFormat('dd-MM-yyyy kk:mm:ss').format(task.end) : ""}')
                          : Text('Tarefa: ${task.id.substring(0, 4)}'),
                      subtitle: Text('${task.toString()}'),
                    ),
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
