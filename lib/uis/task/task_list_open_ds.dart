import 'package:aialuno/models/task_model.dart';
import 'package:aialuno/uis/components/clock.dart';
import 'package:flutter/material.dart';

class TaskListOpenDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;

  const TaskListOpenDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
  }) : super(key: key);

  @override
  _TaskListOpenDSState createState() => _TaskListOpenDSState();
}

class _TaskListOpenDSState extends State<TaskListOpenDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas Open (${widget.taskList.length})'),
        actions: [
          // LogoutButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          final task = widget.taskList[index];
          return Card(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 500,
                  child: task.tempoPResponder == null
                      ? Text('${task.time}')
                      : ListTile(
                          leading: Container(
                            width: 70.0,
                            padding: EdgeInsets.only(top: 3.0, right: 4.0),
                            child: CountDownTimer(
                              secondsRemaining: task.tempoPResponder.inSeconds,
                              whenTimeExpires: () {
                                Navigator.pop(context);
                                // print('terminou clock');
                              },
                              countDownTimerStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                // height: 2,
                              ),
                            ),
                          ),
                          selected: task?.isOpen != null ? task.isOpen : false,
                          title: Text('${task.id.substring(0, 4)}'),
                          subtitle: Text('${task.toString()}'),
                          trailing: IconButton(
                            tooltip: 'Editar esta tarefa',
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              widget.onEditTaskCurrent(task.id);
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
