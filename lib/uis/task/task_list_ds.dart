import 'package:aialuno/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListDS extends StatefulWidget {
  final List<TaskModel> taskList;
  final Function(String) onEditTaskCurrent;

  const TaskListDS({
    Key key,
    this.taskList,
    this.onEditTaskCurrent,
  }) : super(key: key);

  @override
  _TaskListDSState createState() => _TaskListDSState();
}

class _TaskListDSState extends State<TaskListDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico com ${widget.taskList.length} tarefa(s).'),
        actions: [
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
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    Container(
                      // width: 500,
                      child: ListTile(
                        selected: task?.isOpen != null ? task.isOpen : false,
                        title: Text('${task.id.substring(0, 4)}'),
                        subtitle: Text('${task.toString()}'),
                        trailing: task.started != null
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
                            : IconButton(
                                tooltip: 'Proposta da tarefa',
                                icon: Icon(Icons.link),
                                onPressed: null,
                              ),
                      ),
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
