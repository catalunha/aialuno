import 'package:aialuno/models/task_model.dart';
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
                  child: ListTile(
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
